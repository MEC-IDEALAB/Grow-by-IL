-- DRAFT / LOCAL REHEARSAL ONLY. NOT APPROVED FOR LIVE EXECUTION.
-- Prefer a data-preserving forward fix after any client activity. This rollback
-- supports ONLY a pristine installation using either the same-session original
-- snapshot or the candidate-owned persisted original baseline across connections.
-- It never deletes/clears user values. The owner is the trust boundary: this is
-- not tamper protection from postgres or a compromised administrative connection.
-- It restores the original legacy permissions, including their known privacy /
-- authority weaknesses: keep both clients offline until a reviewed forward fix.
-- No storage, operational tables, Auth identities or legacy user fields change.
--
-- Rehearsal / future reviewed runbook (postgres; psql ON_ERROR_STOP):
--   BEGIN;
--   SET LOCAL idealab.profile_rollback_maintenance = 'clients_offline';
--   SET LOCAL idealab.profile_rollback_provenance = 'reviewed-local-fixture';
--   SET LOCAL idealab.profile_rollback_action = 'capture';
--   \i shared_profile_contract_v1_rollback.sql
--   \i shared_profile_contract_v1.sql
--   SET LOCAL idealab.profile_rollback_action = 'rollback';
--   \i shared_profile_contract_v1_rollback.sql
--   \i ../tests/shared_profile_contract_v1_rollback_checks.sql
--   ROLLBACK;
-- Snapshot contains original-row fingerprints and ACLs in a postgres-owned TEMP table; never
-- print/export it to logs or commit it. Supply real review provenance rather than
-- the fixture label outside a fixture. No saved snapshot means refusal; do not
-- reconstruct an original state from defaults or post-install rows. Capture may
-- precede COMMIT, but requires the same connection/database/owner afterward.
-- Persisted path (separate connection after candidate COMMIT): set maintenance
-- as above; set provenance='shared-profile-contract-v1-reviewed-preinstall' and
-- action='persisted-rollback', then execute this file. The candidate itself captured
-- the original baseline atomically before DDL. No session TEMP prerequisite.
-- No baseline means refusal. API roles, even service_role, have no access to it.
-- Fingerprints compare current state, not an audit trail of reverted writes;
-- the separate clients-offline prerequisite is mandatory. Only selected Auth
-- identity fields are compared; credential/session fields are never inspected.

DO $profile_rollback$
DECLARE
  v_action text := current_setting('idealab.profile_rollback_action',true);
  v_snapshot jsonb;
  v_policy record;
  v_item record;
  v_principal text;
  v_roles text;
  v_command text;
  v_columns text[] := ARRAY['institution','department','study_year',
    'profile_contract_version','profile_revision'];
BEGIN
  IF current_user <> 'postgres'
    OR current_setting('server_version_num')::integer NOT BETWEEN 170000 AND 179999
    OR current_setting('idealab.profile_rollback_maintenance',true) IS DISTINCT FROM 'clients_offline'
    OR nullif(btrim(current_setting('idealab.profile_rollback_provenance',true)),'') IS NULL
    OR v_action IS NULL OR v_action NOT IN ('capture','rollback','persisted-rollback')
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_roles WHERE rolname=current_user AND rolbypassrls)
    OR pg_catalog.to_regclass('public.users') IS NULL
    OR pg_catalog.to_regclass('auth.users') IS NULL THEN
    RAISE EXCEPTION 'reviewed rollback requires explicit maintenance, provenance and PostgreSQL 17 owner session';
  END IF;
  -- Lock in Auth -> users order, consistent with Auth provisioning writes.
  LOCK TABLE auth.users IN ACCESS EXCLUSIVE MODE;
  LOCK TABLE public.users IN ACCESS EXCLUSIVE MODE;

  IF v_action='capture' THEN
    IF pg_catalog.to_regclass('pg_temp.idealab_profile_v1_original_snapshot') IS NOT NULL
      OR pg_catalog.to_regnamespace('idealab_private') IS NOT NULL
      OR (SELECT count(*) FROM pg_catalog.pg_attribute
        WHERE attrelid='public.users'::regclass AND attnum>0 AND NOT attisdropped)<>19
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_trigger
        WHERE tgrelid IN ('auth.users'::regclass,'public.users'::regclass) AND NOT tgisinternal)
      OR (SELECT count(*) FROM pg_catalog.pg_policies WHERE schemaname='public' AND tablename='users')<>4
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname='public' AND tablename='users'
        AND policyname NOT IN ('users_select_own','users_update_own','users_insert_own','users_read_all'))
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_proc p JOIN pg_catalog.pg_namespace n ON n.oid=p.pronamespace
        WHERE n.nspname='public' AND p.proname IN
          ('get_own_profile_v1','save_own_profile_v1','claim_mec_registration_v1'))
      OR pg_catalog.to_regclass('public.users_college_roll_normalized_v1_uidx') IS NOT NULL THEN
      RAISE EXCEPTION 'snapshot requires pristine reviewed preinstall baseline';
    END IF;
    IF (SELECT relowner FROM pg_catalog.pg_class WHERE oid='public.users'::regclass)<>current_user::regrole
      OR NOT (SELECT relrowsecurity FROM pg_catalog.pg_class WHERE oid='public.users'::regclass)
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_class c,
        LATERAL pg_catalog.aclexplode(coalesce(c.relacl,pg_catalog.acldefault('r',c.relowner))) a
        WHERE c.oid='public.users'::regclass AND a.grantor<>current_user::regrole)
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_attribute c,
        LATERAL pg_catalog.aclexplode(c.attacl) a
        WHERE c.attrelid='public.users'::regclass AND a.grantor<>current_user::regrole) THEN
      RAISE EXCEPTION 'original grantor/owner requires a separately reviewed restoration strategy';
    END IF;
    CREATE TEMP TABLE idealab_profile_v1_original_snapshot(snapshot jsonb NOT NULL)
      ON COMMIT PRESERVE ROWS;
    REVOKE ALL ON TABLE pg_temp.idealab_profile_v1_original_snapshot FROM PUBLIC,anon,authenticated,service_role;
    INSERT INTO pg_temp.idealab_profile_v1_original_snapshot
    SELECT jsonb_build_object(
      'format','shared-profile-pristine-rollback-v1',
      'provenance',current_setting('idealab.profile_rollback_provenance'),
      'backend_pid',pg_backend_pid(),'database_oid',(SELECT oid FROM pg_catalog.pg_database WHERE datname=current_database()),
      'users_oid','public.users'::regclass::oid,'auth_oid','auth.users'::regclass::oid,
      'users_fingerprint',md5(coalesce((SELECT jsonb_agg(to_jsonb(u) ORDER BY id) FROM public.users u),'[]'::jsonb)::text),
      'auth_fingerprint',md5(coalesce((SELECT jsonb_agg(jsonb_build_object('id',id,'email',email,
        'confirmed',email_confirmed_at,'anonymous',is_anonymous) ORDER BY id) FROM auth.users),'[]'::jsonb)::text),
      'rls',(SELECT jsonb_build_object('enabled',relrowsecurity,'forced',relforcerowsecurity)
        FROM pg_catalog.pg_class WHERE oid='public.users'::regclass),
      'columns',(SELECT jsonb_agg(jsonb_build_object('name',attname,'type',atttypid,
        'typmod',atttypmod,'notnull',attnotnull,'generated',attgenerated,'identity',attidentity,
        'default',pg_catalog.pg_get_expr(d.adbin,d.adrelid)) ORDER BY attnum)
        FROM pg_catalog.pg_attribute a LEFT JOIN pg_catalog.pg_attrdef d ON d.adrelid=a.attrelid AND d.adnum=a.attnum
        WHERE a.attrelid='public.users'::regclass AND a.attnum>0 AND NOT a.attisdropped),
      'constraints',(SELECT jsonb_agg(jsonb_build_object('name',conname,
        'definition',pg_catalog.pg_get_constraintdef(oid)) ORDER BY conname)
        FROM pg_catalog.pg_constraint WHERE conrelid='public.users'::regclass),
      'indexes',(SELECT jsonb_agg(pg_catalog.pg_get_indexdef(indexrelid) ORDER BY indexrelid::regclass::text)
        FROM pg_catalog.pg_index WHERE indrelid='public.users'::regclass),
      'policies',coalesce((SELECT jsonb_agg(jsonb_build_object('name',p.polname,'permissive',p.polpermissive,
        'command',p.polcmd,'roles',(SELECT jsonb_agg(CASE WHEN r=0 THEN 'PUBLIC' ELSE pg_catalog.pg_get_userbyid(r) END ORDER BY r)
          FROM unnest(p.polroles) r),
        'using',pg_catalog.pg_get_expr(p.polqual,p.polrelid),
        'check',pg_catalog.pg_get_expr(p.polwithcheck,p.polrelid)) ORDER BY p.polname)
        FROM pg_catalog.pg_policy p WHERE p.polrelid='public.users'::regclass),'[]'::jsonb),
      'table_acl',coalesce((SELECT jsonb_agg(jsonb_build_object('grantee',a.grantee,
        'privilege',a.privilege_type,'grantable',a.is_grantable) ORDER BY a.grantee,a.privilege_type)
        FROM pg_catalog.pg_class c,
        LATERAL pg_catalog.aclexplode(coalesce(c.relacl,pg_catalog.acldefault('r',c.relowner))) a
        WHERE c.oid='public.users'::regclass),'[]'::jsonb),
      'column_acl',coalesce((SELECT jsonb_agg(jsonb_build_object('column',c.attname,'grantee',a.grantee,
        'privilege',a.privilege_type,'grantable',a.is_grantable) ORDER BY c.attname,a.grantee,a.privilege_type)
        FROM pg_catalog.pg_attribute c,LATERAL pg_catalog.aclexplode(c.attacl) a
        WHERE c.attrelid='public.users'::regclass AND c.attnum>0 AND NOT c.attisdropped),'[]'::jsonb));
    RETURN;
  END IF;

  IF v_action='persisted-rollback' THEN
    IF pg_catalog.to_regclass('idealab_private.profile_contract_baseline_v1') IS NULL
      OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
        WHERE c.oid=pg_catalog.to_regclass('idealab_private.profile_contract_baseline_v1')
          AND c.relowner=current_user::regrole AND n.nspowner=current_user::regrole
          AND c.relkind='r' AND c.relpersistence='p' AND c.relrowsecurity AND c.relforcerowsecurity)
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_class c,LATERAL pg_catalog.aclexplode(c.relacl) a
        WHERE c.oid=pg_catalog.to_regclass('idealab_private.profile_contract_baseline_v1')
          AND a.grantee<>current_user::regrole)
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_attribute c,LATERAL pg_catalog.aclexplode(c.attacl) a
        WHERE c.attrelid=pg_catalog.to_regclass('idealab_private.profile_contract_baseline_v1')
          AND a.grantee<>current_user::regrole)
      OR EXISTS(SELECT 1 FROM pg_catalog.pg_policy
        WHERE polrelid=pg_catalog.to_regclass('idealab_private.profile_contract_baseline_v1')) THEN
      RAISE EXCEPTION 'trusted private persisted baseline required; use forward fix';
    END IF;
    LOCK TABLE idealab_private.profile_contract_baseline_v1 IN ACCESS EXCLUSIVE MODE;
    IF (SELECT count(*) FROM idealab_private.profile_contract_baseline_v1)<>1 THEN
      RAISE EXCEPTION 'persisted baseline cardinality invalid';
    END IF;
    SELECT snapshot INTO v_snapshot FROM idealab_private.profile_contract_baseline_v1;
    IF v_snapshot->>'format' IS DISTINCT FROM 'shared-profile-persisted-pristine-rollback-v1'
      OR v_snapshot->>'provenance' IS DISTINCT FROM 'shared-profile-contract-v1-reviewed-preinstall'
      OR current_setting('idealab.profile_rollback_provenance') IS DISTINCT FROM v_snapshot->>'provenance' THEN
      RAISE EXCEPTION 'persisted baseline provenance mismatch';
    END IF;
    -- Only disposable tests retain a private TEMP copy for post-DROP assertions.
    IF current_setting('idealab.sql_fixture_only',true)='true' THEN
      IF pg_catalog.to_regclass('pg_temp.idealab_profile_v1_original_snapshot') IS NOT NULL THEN
        RAISE EXCEPTION 'persisted rollback rehearsal requires no competing temp snapshot';
      END IF;
      CREATE TEMP TABLE idealab_profile_v1_original_snapshot(snapshot jsonb NOT NULL) ON COMMIT PRESERVE ROWS;
      REVOKE ALL ON pg_temp.idealab_profile_v1_original_snapshot FROM PUBLIC,anon,authenticated,service_role;
      INSERT INTO pg_temp.idealab_profile_v1_original_snapshot VALUES(v_snapshot);
    END IF;
  ELSE
    IF pg_catalog.to_regclass('pg_temp.idealab_profile_v1_original_snapshot') IS NULL
      OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_class WHERE oid=pg_catalog.to_regclass('pg_temp.idealab_profile_v1_original_snapshot')
        AND relowner=current_user::regrole AND relpersistence='t') THEN
      RAISE EXCEPTION 'genuine original session snapshot required; use forward fix';
    END IF;
    IF (SELECT count(*) FROM pg_temp.idealab_profile_v1_original_snapshot)<>1 THEN
      RAISE EXCEPTION 'original snapshot cardinality invalid';
    END IF;
    SELECT snapshot INTO v_snapshot FROM pg_temp.idealab_profile_v1_original_snapshot;
    IF v_snapshot->>'format' IS DISTINCT FROM 'shared-profile-pristine-rollback-v1'
      OR v_snapshot->>'provenance' IS DISTINCT FROM current_setting('idealab.profile_rollback_provenance')
      OR (v_snapshot->>'backend_pid')::integer IS DISTINCT FROM pg_backend_pid() THEN
      RAISE EXCEPTION 'temporary snapshot provenance/session mismatch';
    END IF;
  END IF;
  IF (v_snapshot->>'database_oid')::oid IS DISTINCT FROM (SELECT oid FROM pg_catalog.pg_database WHERE datname=current_database())
    OR (v_snapshot->>'users_oid')::oid IS DISTINCT FROM 'public.users'::regclass::oid
    OR (v_snapshot->>'auth_oid')::oid IS DISTINCT FROM 'auth.users'::regclass::oid
    OR pg_catalog.to_regnamespace('idealab_private') IS NULL THEN
    RAISE EXCEPTION 'snapshot database/object mismatch';
  END IF;
  LOCK TABLE idealab_private.mec_registration_claims_v1 IN ACCESS EXCLUSIVE MODE;
  LOCK TABLE idealab_private.mec_registration_collision_state_v1 IN ACCESS EXCLUSIVE MODE;
  IF EXISTS(SELECT 1 FROM idealab_private.mec_registration_claims_v1)
    OR EXISTS(SELECT 1 FROM idealab_private.mec_registration_collision_state_v1)
    OR EXISTS(SELECT 1 FROM public.users WHERE institution IS NOT NULL OR department IS NOT NULL
      OR study_year IS NOT NULL OR profile_contract_version<>0 OR profile_revision<>0)
    OR md5(coalesce((SELECT jsonb_agg(to_jsonb(u)-v_columns ORDER BY id) FROM public.users u),'[]'::jsonb)::text)
      IS DISTINCT FROM v_snapshot->>'users_fingerprint'
    OR md5(coalesce((SELECT jsonb_agg(jsonb_build_object('id',id,'email',email,
        'confirmed',email_confirmed_at,'anonymous',is_anonymous) ORDER BY id) FROM auth.users),'[]'::jsonb)::text)
      IS DISTINCT FROM v_snapshot->>'auth_fingerprint' THEN
    RAISE EXCEPTION 'postinstall account/claim activity detected; rollback refused, preserve data and forward fix';
  END IF;
  IF (SELECT count(*) FROM pg_catalog.pg_policies WHERE schemaname='public' AND tablename='users')<>1
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname='public' AND tablename='users'
      AND policyname='users_verified_owner_read_v1')
    OR (SELECT count(*) FROM pg_catalog.pg_attribute WHERE attrelid='public.users'::regclass
      AND attnum>0 AND NOT attisdropped)<>24 THEN
    RAISE EXCEPTION 'postinstall schema drift requires separate review';
  END IF;
  IF (SELECT jsonb_agg(jsonb_build_object('name',attname,'type',atttypid,
      'typmod',atttypmod,'notnull',attnotnull,'generated',attgenerated,'identity',attidentity,
      'default',pg_catalog.pg_get_expr(d.adbin,d.adrelid)) ORDER BY attnum)
      FROM pg_catalog.pg_attribute a LEFT JOIN pg_catalog.pg_attrdef d ON d.adrelid=a.attrelid AND d.adnum=a.attnum
      WHERE a.attrelid='public.users'::regclass AND a.attnum>0 AND NOT a.attisdropped
        AND NOT a.attname=ANY(v_columns)) IS DISTINCT FROM v_snapshot->'columns'
    OR (SELECT jsonb_agg(jsonb_build_object('name',conname,
      'definition',pg_catalog.pg_get_constraintdef(oid)) ORDER BY conname)
      FROM pg_catalog.pg_constraint WHERE conrelid='public.users'::regclass
        AND conname NOT IN ('users_study_year_v1_check','users_profile_contract_v1_check','users_profile_revision_v1_check'))
      IS DISTINCT FROM v_snapshot->'constraints'
    OR (SELECT jsonb_agg(pg_catalog.pg_get_indexdef(indexrelid) ORDER BY indexrelid::regclass::text)
      FROM pg_catalog.pg_index WHERE indrelid='public.users'::regclass
        AND indexrelid<>'public.users_college_roll_normalized_v1_uidx'::regclass)
      IS DISTINCT FROM v_snapshot->'indexes'
    OR (SELECT count(*) FROM pg_catalog.pg_trigger WHERE tgrelid='auth.users'::regclass AND NOT tgisinternal)<>2
    OR EXISTS(SELECT 1 FROM pg_catalog.pg_trigger WHERE tgrelid='public.users'::regclass AND NOT tgisinternal) THEN
    RAISE EXCEPTION 'legacy schema/trigger drift detected; rollback refused';
  END IF;

  DROP TRIGGER shared_profile_after_auth_insert_v1 ON auth.users;
  DROP TRIGGER shared_profile_after_auth_update_v1 ON auth.users;
  DROP POLICY users_verified_owner_read_v1 ON public.users;
  DROP FUNCTION public.get_own_profile_v1();
  DROP FUNCTION public.save_own_profile_v1(jsonb,text);
  DROP FUNCTION public.claim_mec_registration_v1(text,text,boolean);
  DROP INDEX public.users_college_roll_normalized_v1_uidx;
  DROP TABLE idealab_private.profile_contract_baseline_v1;
  DROP TABLE idealab_private.mec_registration_claims_v1;
  DROP TABLE idealab_private.mec_registration_collision_state_v1;
  DROP FUNCTION idealab_private.enforce_no_committed_pending_mec_claim_v1();
  DROP FUNCTION idealab_private.provision_shared_profile_v1();
  DROP FUNCTION idealab_private.ensure_current_profile_v1();
  DROP FUNCTION idealab_private.save_current_profile_v1(jsonb,text);
  DROP FUNCTION idealab_private.claim_current_mec_registration_v1(text,text,boolean);
  DROP FUNCTION idealab_private.current_student_mec_admitted_v1();
  DROP FUNCTION idealab_private.validate_required_profile_v1(jsonb,smallint);
  DROP FUNCTION idealab_private.validate_mec_claim_display_v1(text);
  DROP FUNCTION idealab_private.has_current_verified_email_v1();
  DROP FUNCTION idealab_private.normalize_mec_registration_v1(text);
  DROP COLLATION idealab_private.mec_registration_ci;
  -- RESTRICT default: unknown objects/dependencies abort the whole statement.
  DROP SCHEMA idealab_private;

  -- Revoke every current table/column grant recipient, then restore only the
  -- original owner-issued grants, preserving grant options and column scope.
  FOR v_item IN SELECT DISTINCT a.grantee FROM pg_catalog.pg_class c,
      LATERAL pg_catalog.aclexplode(coalesce(c.relacl,pg_catalog.acldefault('r',c.relowner))) a
      WHERE c.oid='public.users'::regclass
      UNION SELECT DISTINCT a.grantee FROM pg_catalog.pg_attribute c,
      LATERAL pg_catalog.aclexplode(c.attacl) a WHERE c.attrelid='public.users'::regclass
  LOOP
    v_principal:=CASE WHEN v_item.grantee=0 THEN 'PUBLIC'
      ELSE quote_ident(pg_catalog.pg_get_userbyid(v_item.grantee)) END;
    EXECUTE format('REVOKE ALL ON TABLE public.users FROM %s',v_principal);
    FOR v_policy IN SELECT attname FROM pg_catalog.pg_attribute WHERE attrelid='public.users'::regclass
      AND attnum>0 AND NOT attisdropped LOOP
      EXECUTE format('REVOKE SELECT(%1$I),INSERT(%1$I),UPDATE(%1$I),REFERENCES(%1$I) ON public.users FROM %2$s',
        v_policy.attname,v_principal);
    END LOOP;
  END LOOP;
  ALTER TABLE public.users DROP COLUMN institution, DROP COLUMN department,
    DROP COLUMN study_year, DROP COLUMN profile_contract_version, DROP COLUMN profile_revision;
  FOR v_item IN SELECT value FROM jsonb_array_elements(v_snapshot->'table_acl') LOOP
    v_principal:=CASE WHEN (v_item.value->>'grantee')::oid=0 THEN 'PUBLIC'
      ELSE quote_ident(pg_catalog.pg_get_userbyid((v_item.value->>'grantee')::oid)) END;
    EXECUTE format('GRANT %s ON TABLE public.users TO %s%s',v_item.value->>'privilege',v_principal,
      CASE WHEN (v_item.value->>'grantable')::boolean THEN ' WITH GRANT OPTION' ELSE '' END);
  END LOOP;
  FOR v_item IN SELECT value FROM jsonb_array_elements(v_snapshot->'column_acl') LOOP
    v_principal:=CASE WHEN (v_item.value->>'grantee')::oid=0 THEN 'PUBLIC'
      ELSE quote_ident(pg_catalog.pg_get_userbyid((v_item.value->>'grantee')::oid)) END;
    EXECUTE format('GRANT %s(%I) ON public.users TO %s%s',v_item.value->>'privilege',v_item.value->>'column',
      v_principal,CASE WHEN (v_item.value->>'grantable')::boolean THEN ' WITH GRANT OPTION' ELSE '' END);
  END LOOP;
  FOR v_item IN SELECT value FROM jsonb_array_elements(v_snapshot->'policies') LOOP
    SELECT string_agg(CASE WHEN r='PUBLIC' THEN 'PUBLIC' ELSE quote_ident(r) END,',') INTO v_roles
      FROM jsonb_array_elements_text(v_item.value->'roles') r;
    v_command:=CASE v_item.value->>'command' WHEN '*' THEN 'ALL' WHEN 'r' THEN 'SELECT'
      WHEN 'a' THEN 'INSERT' WHEN 'w' THEN 'UPDATE' WHEN 'd' THEN 'DELETE' END;
    EXECUTE format('CREATE POLICY %I ON public.users AS %s FOR %s TO %s%s%s',v_item.value->>'name',
      CASE WHEN (v_item.value->>'permissive')::boolean THEN 'PERMISSIVE' ELSE 'RESTRICTIVE' END,v_command,v_roles,
      CASE WHEN v_item.value->>'using' IS NULL THEN '' ELSE ' USING ('||(v_item.value->>'using')||')' END,
      CASE WHEN v_item.value->>'check' IS NULL THEN '' ELSE ' WITH CHECK ('||(v_item.value->>'check')||')' END);
  END LOOP;
  ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
  EXECUTE 'ALTER TABLE public.users '||CASE WHEN (v_snapshot#>>'{rls,forced}')::boolean THEN 'FORCE' ELSE 'NO FORCE' END||' ROW LEVEL SECURITY';
END;
$profile_rollback$;
