-- LOCAL-ONLY pristine rollback rehearsal assertions, after capture/install/
-- rollback in the same postgres connection; wrap the whole rehearsal in ROLLBACK.
-- Compare fingerprints and reviewed catalog metadata, never emit private rows.
-- This proves no live Auth/login journey and authorizes no real rollback.
DO $rollback_checks$
DECLARE
  v_snapshot jsonb;
  v_actual jsonb;
BEGIN
  IF current_user<>'postgres'
    OR current_setting('idealab.sql_fixture_only',true) IS DISTINCT FROM 'true'
    THEN
    RAISE EXCEPTION 'rollback checks require the explicit disposable local fixture';
  END IF;
  -- Invoke once after install with phase=installed, then once after rollback with
  -- phase=restored (the default). This branch never claims restoration passed.
  IF current_setting('idealab.profile_rollback_check_phase',true)='installed' THEN
    IF pg_catalog.to_regclass('idealab_private.profile_contract_baseline_v1') IS NULL
      OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_class WHERE oid='idealab_private.profile_contract_baseline_v1'::regclass
        AND relowner=current_user::regrole AND relrowsecurity AND relforcerowsecurity AND relpersistence='p')
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_policy WHERE polrelid='idealab_private.profile_contract_baseline_v1'::regclass)
      OR EXISTS(SELECT 1 FROM unnest(ARRAY['anon','authenticated','service_role']) r
        WHERE pg_catalog.has_table_privilege(r,'idealab_private.profile_contract_baseline_v1',
          'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER,MAINTAIN'))
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_attribute c,LATERAL pg_catalog.aclexplode(c.attacl) a
        WHERE c.attrelid='idealab_private.profile_contract_baseline_v1'::regclass AND a.grantee<>current_user::regrole)
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_proc p JOIN pg_catalog.pg_namespace n ON n.oid=p.pronamespace
        WHERE n.nspname IN ('public','idealab_private') AND p.prosrc ILIKE '%profile_contract_baseline_v1%')
      OR (SELECT count(*) FROM idealab_private.profile_contract_baseline_v1)<>1 THEN
      RAISE EXCEPTION 'persisted maintenance baseline ownership/access invariant failed';
    END IF;
    SELECT snapshot INTO STRICT v_snapshot FROM idealab_private.profile_contract_baseline_v1;
    IF v_snapshot->>'format' IS DISTINCT FROM 'shared-profile-persisted-pristine-rollback-v1'
      OR v_snapshot->>'provenance' IS DISTINCT FROM 'shared-profile-contract-v1-reviewed-preinstall'
      OR v_snapshot ?| ARRAY['users_rows','auth_rows','encrypted_password','password','token']
      OR (v_snapshot->>'auth_fingerprint') !~ '^[a-f0-9]{32}$'
      OR (v_snapshot->>'users_fingerprint') !~ '^[a-f0-9]{32}$' THEN
      RAISE EXCEPTION 'persisted baseline shape/provenance invariant failed';
    END IF;
    RETURN;
  END IF;
  IF pg_catalog.to_regclass('pg_temp.idealab_profile_v1_original_snapshot') IS NULL THEN
    RAISE EXCEPTION 'rollback restoration checks require retained original snapshot';
  END IF;
  SELECT snapshot INTO STRICT v_snapshot FROM pg_temp.idealab_profile_v1_original_snapshot;
  IF v_snapshot->>'format' IS NULL
    OR v_snapshot->>'format' NOT IN ('shared-profile-pristine-rollback-v1','shared-profile-persisted-pristine-rollback-v1')
    OR (v_snapshot->>'format'='shared-profile-pristine-rollback-v1'
      AND (v_snapshot->>'backend_pid')::integer IS DISTINCT FROM pg_backend_pid())
    OR v_snapshot->>'provenance' IS DISTINCT FROM current_setting('idealab.profile_rollback_provenance') THEN
    RAISE EXCEPTION 'rollback test snapshot provenance mismatch';
  END IF;
  IF md5(coalesce((SELECT jsonb_agg(to_jsonb(u) ORDER BY id) FROM public.users u),'[]'::jsonb)::text)
      IS DISTINCT FROM v_snapshot->>'users_fingerprint'
    OR md5(coalesce((SELECT jsonb_agg(jsonb_build_object('id',id,'email',email,
      'confirmed',email_confirmed_at,'anonymous',is_anonymous) ORDER BY id)
      FROM auth.users),'[]'::jsonb)::text) IS DISTINCT FROM v_snapshot->>'auth_fingerprint' THEN
    RAISE EXCEPTION 'rollback changed original identity/profile data';
  END IF;
  IF pg_catalog.to_regnamespace('idealab_private') IS NOT NULL
    OR pg_catalog.to_regclass('public.users_college_roll_normalized_v1_uidx') IS NOT NULL
    OR EXISTS(SELECT 1 FROM pg_catalog.pg_proc p JOIN pg_catalog.pg_namespace n ON n.oid=p.pronamespace
      WHERE n.nspname='public' AND p.proname IN
        ('get_own_profile_v1','save_own_profile_v1','claim_mec_registration_v1'))
    OR EXISTS(SELECT 1 FROM pg_catalog.pg_trigger WHERE tgrelid IN ('auth.users'::regclass,'public.users'::regclass)
      AND NOT tgisinternal) THEN
    RAISE EXCEPTION 'rollback left shared-contract objects/triggers behind';
  END IF;
  SELECT jsonb_agg(jsonb_build_object('name',attname,'type',atttypid,'typmod',atttypmod,
    'notnull',attnotnull,'generated',attgenerated,'identity',attidentity,
    'default',pg_catalog.pg_get_expr(d.adbin,d.adrelid)) ORDER BY attnum)
    INTO v_actual FROM pg_catalog.pg_attribute a
    LEFT JOIN pg_catalog.pg_attrdef d ON d.adrelid=a.attrelid AND d.adnum=a.attnum
    WHERE a.attrelid='public.users'::regclass AND a.attnum>0 AND NOT a.attisdropped;
  IF v_actual IS DISTINCT FROM v_snapshot->'columns' THEN
    RAISE EXCEPTION 'original 19-column definition not restored';
  END IF;
  SELECT jsonb_agg(jsonb_build_object('name',conname,'definition',pg_catalog.pg_get_constraintdef(oid)) ORDER BY conname)
    INTO v_actual FROM pg_catalog.pg_constraint WHERE conrelid='public.users'::regclass;
  IF v_actual IS DISTINCT FROM v_snapshot->'constraints' THEN
    RAISE EXCEPTION 'original constraints not preserved';
  END IF;
  SELECT jsonb_agg(pg_catalog.pg_get_indexdef(indexrelid) ORDER BY indexrelid::regclass::text)
    INTO v_actual FROM pg_catalog.pg_index WHERE indrelid='public.users'::regclass;
  IF v_actual IS DISTINCT FROM v_snapshot->'indexes' THEN
    RAISE EXCEPTION 'original raw unique/index definitions not preserved';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object('name',p.polname,'permissive',p.polpermissive,
    'command',p.polcmd,'roles',(SELECT jsonb_agg(CASE WHEN r=0 THEN 'PUBLIC' ELSE pg_catalog.pg_get_userbyid(r) END ORDER BY r)
      FROM unnest(p.polroles) r),
    'using',pg_catalog.pg_get_expr(p.polqual,p.polrelid),
    'check',pg_catalog.pg_get_expr(p.polwithcheck,p.polrelid)) ORDER BY p.polname),'[]'::jsonb)
    INTO v_actual FROM pg_catalog.pg_policy p WHERE p.polrelid='public.users'::regclass;
  IF v_actual IS DISTINCT FROM v_snapshot->'policies' THEN
    RAISE EXCEPTION 'original policies not restored';
  END IF;
  SELECT jsonb_build_object('enabled',relrowsecurity,'forced',relforcerowsecurity)
    INTO v_actual FROM pg_catalog.pg_class WHERE oid='public.users'::regclass;
  IF v_actual IS DISTINCT FROM v_snapshot->'rls' THEN
    RAISE EXCEPTION 'original RLS state not restored';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object('grantee',a.grantee,'privilege',a.privilege_type,
    'grantable',a.is_grantable) ORDER BY a.grantee,a.privilege_type),'[]'::jsonb)
    INTO v_actual FROM pg_catalog.pg_class c,
    LATERAL pg_catalog.aclexplode(coalesce(c.relacl,pg_catalog.acldefault('r',c.relowner))) a
    WHERE c.oid='public.users'::regclass;
  IF v_actual IS DISTINCT FROM v_snapshot->'table_acl' THEN
    RAISE EXCEPTION 'original table grant semantics not restored';
  END IF;
  SELECT coalesce(jsonb_agg(jsonb_build_object('column',c.attname,'grantee',a.grantee,
    'privilege',a.privilege_type,'grantable',a.is_grantable) ORDER BY c.attname,a.grantee,a.privilege_type),'[]'::jsonb)
    INTO v_actual FROM pg_catalog.pg_attribute c,LATERAL pg_catalog.aclexplode(c.attacl) a
    WHERE c.attrelid='public.users'::regclass AND c.attnum>0 AND NOT c.attisdropped;
  IF v_actual IS DISTINCT FROM v_snapshot->'column_acl' THEN
    RAISE EXCEPTION 'original column grant semantics not restored';
  END IF;
END;
$rollback_checks$;
SELECT coalesce(nullif(current_setting('idealab.profile_rollback_check_phase',true),''),'restored')
  AS shared_profile_rollback_check_phase, true AS shared_profile_rollback_phase_checks_passed;
