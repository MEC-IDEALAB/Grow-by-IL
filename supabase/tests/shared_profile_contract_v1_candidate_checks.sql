-- DRAFT SHARED PROFILE CANDIDATE CHECKS. No live execution performed.
-- A caller must BEGIN; apply the candidate on an approved, reconciled disposable
-- Supabase-faithful PG17 baseline; run these checks; and ROLLBACK.
-- Existing nonduplicate legacy registration reservations are preserved. Exact
-- normalized duplicates must still abort the candidate; never clear/reassign
-- real registration values to make this test pass.
-- These checks use metadata, pure validation inputs and missing-identity denial.
-- They do not create Auth fixtures, attest claims, verify SMTP/Google, or prove
-- positive account writes, concurrency, cross-client behavior or full rollback.
-- All identifiers and sample form inputs below are test literals, not real users.

DO $catalog$
DECLARE
  v_role text;
  v_name text;
  v_public record;
  v_private record;
BEGIN
  IF pg_catalog.to_regprocedure('public.get_own_profile_v1()') IS NULL
    OR pg_catalog.to_regprocedure('public.save_own_profile_v1(jsonb,text)') IS NULL
    OR pg_catalog.to_regprocedure('public.claim_mec_registration_v1(text,text,boolean)') IS NULL THEN
    RAISE EXCEPTION 'apply the reconciled draft candidate inside the same rollback transaction first';
  END IF;
  SELECT * INTO v_public FROM pg_catalog.pg_proc
    WHERE oid='public.get_own_profile_v1()'::regprocedure;
  IF v_public.provolatile <> 'v' OR NOT v_public.prosecdef
    OR v_public.proowner <> (SELECT oid FROM pg_catalog.pg_roles WHERE rolname='postgres')
    OR v_public.proconfig IS DISTINCT FROM ARRAY['search_path=""']::text[] THEN
    RAISE EXCEPTION 'repairing getter trust boundary differs from reviewed contract';
  END IF;
  IF v_public.pronargs<>0
    OR v_public.proargnames IS DISTINCT FROM ARRAY[
      'id','name','phone','college_roll','institution','department','study_year','role',
      'is_active','profile_completed','profile_contract_version','profile_revision','mec_admitted']::text[]
    OR v_public.proallargtypes IS DISTINCT FROM ARRAY[
      'uuid'::regtype,'text'::regtype,'text'::regtype,'text'::regtype,'text'::regtype,
      'text'::regtype,'smallint'::regtype,'text'::regtype,'boolean'::regtype,
      'boolean'::regtype,'smallint'::regtype,'text'::regtype,'boolean'::regtype]::oid[] THEN
    RAISE EXCEPTION 'own profile shape differs from the shared 13-field client contract';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM pg_catalog.pg_class
      WHERE oid='public.users'::regclass AND relrowsecurity AND relforcerowsecurity)
    OR (SELECT count(*) FROM pg_catalog.pg_policies
      WHERE schemaname='public' AND tablename='users')<>1
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname='public'
      AND tablename='users' AND policyname='users_verified_owner_read_v1'
      AND cmd='SELECT' AND roles=ARRAY['authenticated']::name[]) THEN
    RAISE EXCEPTION 'private own-profile RLS boundary differs';
  END IF;
  FOREACH v_role IN ARRAY ARRAY['anon','authenticated'] LOOP
    IF pg_catalog.has_table_privilege(v_role,'public.users',
      'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER,MAINTAIN') THEN
      RAISE EXCEPTION 'API role retains full-account table privileges';
    END IF;
    FOREACH v_name IN ARRAY ARRAY['role','is_active','profile_completed',
      'profile_contract_version','profile_revision','email','ban_reason','banned_at'] LOOP
      IF pg_catalog.has_column_privilege(v_role,'public.users',v_name,'INSERT,UPDATE,REFERENCES') THEN
        RAISE EXCEPTION 'API role retains authority/identity write permission';
      END IF;
    END LOOP;
    IF pg_catalog.has_column_privilege(v_role,'public.users','email','SELECT')
      OR pg_catalog.has_column_privilege(v_role,'public.users','ban_reason','SELECT') THEN
      RAISE EXCEPTION 'private account fields are directly selectable';
    END IF;
  END LOOP;
  FOREACH v_role IN ARRAY ARRAY['anon','authenticated','service_role'] LOOP
    FOREACH v_name IN ARRAY ARRAY[
      'idealab_private.mec_registration_claims_v1',
      'idealab_private.mec_registration_collision_state_v1'] LOOP
      IF pg_catalog.has_table_privilege(v_role,v_name,
        'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER,MAINTAIN') THEN
        RAISE EXCEPTION 'private claim/collision table reachable by API role';
      END IF;
    END LOOP;
    IF pg_catalog.has_function_privilege(v_role,'public.get_own_profile_v1()','EXECUTE')
       IS DISTINCT FROM (v_role='authenticated')
      OR pg_catalog.has_function_privilege(v_role,'public.save_own_profile_v1(jsonb,text)','EXECUTE')
       IS DISTINCT FROM (v_role='authenticated')
      OR pg_catalog.has_function_privilege(v_role,'public.claim_mec_registration_v1(text,text,boolean)','EXECUTE')
       IS DISTINCT FROM (v_role='authenticated') THEN
      RAISE EXCEPTION 'public RPC execution privileges differ';
    END IF;
    FOR v_private IN SELECT oid,proname,prosecdef,proconfig FROM pg_catalog.pg_proc
      WHERE pronamespace='idealab_private'::regnamespace LOOP
      IF pg_catalog.has_function_privilege(v_role,v_private.oid,'EXECUTE')
        IS DISTINCT FROM (v_role='authenticated' AND v_private.proname=ANY(ARRAY[
          'has_current_verified_email_v1','current_student_mec_admitted_v1',
          'save_current_profile_v1','claim_current_mec_registration_v1'])
          OR (v_role='service_role' AND v_private.proname='normalize_mec_registration_v1')) THEN
        RAISE EXCEPTION 'unexpected private routine caller';
      END IF;
      IF v_private.proconfig IS DISTINCT FROM ARRAY['search_path=""']::text[] THEN
        RAISE EXCEPTION 'private routine search path is not fixed';
      END IF;
    END LOOP;
  END LOOP;
  IF NOT EXISTS(SELECT 1 FROM pg_catalog.pg_trigger
    WHERE tgrelid='idealab_private.mec_registration_claims_v1'::regclass
      AND tgname='mec_registration_claims_v1_no_pending_at_commit'
      AND tgdeferrable AND tginitdeferred AND tgenabled='O')
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_proc
      WHERE oid='idealab_private.enforce_no_committed_pending_mec_claim_v1()'::regprocedure
        AND prosecdef) THEN
    RAISE EXCEPTION 'fixed-target deferred pending-claim guard missing';
  END IF;
  IF (SELECT count(*) FROM pg_catalog.pg_trigger WHERE tgrelid='auth.users'::regclass
    AND NOT tgisinternal AND tgname IN
      ('shared_profile_after_auth_insert_v1','shared_profile_after_auth_update_v1'))<>2 THEN
    RAISE EXCEPTION 'confirmed-identity provisioning triggers missing';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM pg_catalog.pg_constraint
    WHERE conrelid='public.users'::regclass AND conname='users_college_roll_key' AND contype='u')
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_index i
      WHERE i.indexrelid='public.users_college_roll_normalized_v1_uidx'::regclass
        AND i.indrelid='public.users'::regclass AND i.indisunique AND i.indisvalid
        AND i.indnkeyatts=1 AND NOT i.indnullsnotdistinct
        AND i.indexprs IS NOT NULL AND i.indpred IS NOT NULL
        AND i.indcollation[0]='idealab_private.mec_registration_ci'::regcollation
        AND pg_catalog.pg_get_expr(i.indpred,i.indrelid)='(college_roll IS NOT NULL)')
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_depend
      WHERE classid='pg_class'::regclass
        AND objid='public.users_college_roll_normalized_v1_uidx'::regclass
        AND refclassid='pg_proc'::regclass
        AND refobjid='idealab_private.normalize_mec_registration_v1(text)'::regprocedure) THEN
    RAISE EXCEPTION 'raw/normalized registration reservation index contract differs';
  END IF;
END;
$catalog$;

DO $validation$
DECLARE
  v_result record;
  v_complete jsonb := '{"name":"Test Member","phone":"+919876543210","college_roll":"MDL24CS001","institution":"Model Engineering College","department":"Computer Science","study_year":2}';
BEGIN
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(v_complete,0::smallint);
  IF v_result.valid IS DISTINCT FROM true OR v_result.complete IS DISTINCT FROM true THEN
    RAISE EXCEPTION 'bounded complete profile rejected';
  END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    '{"name":"","phone":null,"college_roll":null,"institution":null,"department":null,"study_year":null}',0::smallint);
  IF v_result.valid IS DISTINCT FROM true OR v_result.complete IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'partial initial profile contract differs';
  END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||'{"role":"super_admin"}',0::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'authority payload accepted'; END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||'{"phone":"9876543210"}',0::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'phone without country code accepted'; END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||'{"study_year":2.5}',0::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'fractional study year accepted'; END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||'{"institution":"Different Institution"}',0::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'noncanonical pilot institution accepted'; END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||pg_catalog.jsonb_build_object('name',E'bad\nname'),0::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'control character accepted'; END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||pg_catalog.jsonb_build_object('college_roll',pg_catalog.repeat(' ',4097)),0::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'oversized raw input accepted'; END IF;
  SELECT * INTO v_result FROM idealab_private.validate_required_profile_v1(
    v_complete||'{"department":null}',1::smallint);
  IF v_result.valid IS DISTINCT FROM false THEN RAISE EXCEPTION 'completed profile downgrade accepted'; END IF;
  IF idealab_private.normalize_mec_registration_v1(E'  mDl24CS001\t')
       COLLATE idealab_private.mec_registration_ci
       IS DISTINCT FROM 'MDL24CS001' COLLATE idealab_private.mec_registration_ci
    OR 'MDL 24' COLLATE idealab_private.mec_registration_ci =
       'MDL24' COLLATE idealab_private.mec_registration_ci
    OR 'MDLé' COLLATE idealab_private.mec_registration_ci =
       'MDLe' COLLATE idealab_private.mec_registration_ci THEN
    RAISE EXCEPTION 'reviewed whitespace/case/accent comparison semantics differ';
  END IF;
  IF idealab_private.validate_mec_claim_display_v1('LMDL24CS001') IS DISTINCT FROM true
    OR idealab_private.validate_mec_claim_display_v1('ARBITRARY001') IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'pilot prefix check differs';
  END IF;
END;
$validation$;

SET LOCAL request.jwt.claims='{}';
SET LOCAL request.jwt.claim.sub='';
SET LOCAL ROLE authenticated;
DO $missing_identity$
DECLARE v_result record;
BEGIN
  IF EXISTS(SELECT 1 FROM public.get_own_profile_v1()) THEN
    RAISE EXCEPTION 'missing identity produced an account projection';
  END IF;
  SELECT * INTO v_result FROM public.save_own_profile_v1('{}','0');
  IF v_result.status IS DISTINCT FROM 'verification_required' OR v_result.profile_revision IS NOT NULL THEN
    RAISE EXCEPTION 'save accepted a missing identity';
  END IF;
  SELECT * INTO v_result FROM public.claim_mec_registration_v1('MDL24CS001','0',true);
  IF v_result.status IS DISTINCT FROM 'verification_required' OR v_result.profile_revision IS NOT NULL THEN
    RAISE EXCEPTION 'claim accepted a missing identity';
  END IF;
END;
$missing_identity$;
RESET ROLE;

SELECT true AS candidate_catalog_and_negative_checks_passed;
-- Caller must ROLLBACK and verify baseline catalogs/identities are restored.

