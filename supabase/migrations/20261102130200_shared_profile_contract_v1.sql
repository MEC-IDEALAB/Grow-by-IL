SET LOCAL lock_timeout='5s';
SET LOCAL statement_timeout='30s';
-- DRAFT SHARED PROFILE CONTRACT V1 — NOT INSTALLED / NOT RELEASE-APPROVED.
-- Owner: main agent must review before any execution. Run only as one atomic
-- statement against a reconciled PostgreSQL 17 Supabase baseline.
--
-- Existing auth.users IDs, users rows, role/is_active/ban fields, values, FKs,
-- operational tables and stored files are preserved. No account/claim backfill.
-- A postgres-owned private original-metadata/fingerprint record permits only a
-- pristine reviewed rollback across administrative connections. It is not a
-- backup, an audit log or protection from a compromised database owner.
-- Persisted state is SQL-maintenance-only (forced RLS, no policies, no API-role
-- grants and no RPC). It contains catalog metadata and aggregate MD5 comparison
-- fingerprints; no private row JSON, Auth credentials or session tokens persist.
-- This expands the existing users table; it does not replay migrations 001–008.
--
-- Legacy non-NULL users.college_roll values remain ordinary reservations with
-- their display text unchanged. Keep the raw unique constraint and add the
-- approved whitespace/ICU-normalized unique index over the same column. Abort
-- generically on normalized duplicates; never clear/reassign values or silently
-- convert them into attested claims. Legacy profiles start at contract version 0
-- and the claim table stays empty until an owner explicitly saves and declares.
-- The parent's 2 November aggregate inventory reports TWO legacy values; that
-- count alone neither blocks this preservation strategy nor proves eligibility.
--
-- New/missing profiles are provisioned only for a currently confirmed,
-- nonanonymous Auth identity, with ordinary student defaults. Existing rows,
-- elevated roles and inactive/ban state are never overwritten by provisioning.
-- A verified email/domain/MDL prefix does not prove college eligibility.
--
-- APIs expose the exact 13-field website/Flutter own-profile shape, decimal-text
-- revisions, six-field optimistic saves, and explicit atomic MEC declaration/
-- normalized-number claims. Claim collision limit is five per fifteen minutes.
-- No role/position/active/completion/admission authority is accepted from clients.
--
-- CUTOVER GATE: both default clients must use these APIs before installation.
-- Direct users INSERT/UPDATE and broad full-row reads are intentionally removed;
-- legacy Flutter auth/profile/onboarding and team-name reads will need adapters.
-- No operational API, storage policy, password recovery or auth-provider setting
-- is changed. Security-definer owners are privileged postgres with fixed bodies,
-- empty search_path and caller checks; this is not a least-privileged-owner claim.
--
-- Source adaptations: website supabase/validation reviewed read/provision,
-- save, admission, registration-claim and fixed-target pending-guard candidates.
-- Those validation files themselves must NEVER be deployed wholesale to Grow.
-- The earlier blanket legacy-registration preflight refusal was exercised on
-- Grow in a rolled-back trial; that earlier result does not verify this revised
-- normalized-preservation candidate. Full migration/API/provider behavior remains
-- unexecuted unless separately reported against a disposable faithful fixture.

DO $shared_profile_candidate$
DECLARE
  v_role text;
  v_column record;
  v_original_baseline jsonb;
BEGIN
  IF current_user <> 'postgres'
    OR current_setting('server_version_num')::integer NOT BETWEEN 170000 AND 179999
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_roles WHERE rolname=current_user AND rolbypassrls)
    OR pg_catalog.to_regclass('public.users') IS NULL
    OR pg_catalog.to_regclass('auth.users') IS NULL
    OR pg_catalog.to_regprocedure('auth.uid()') IS NULL THEN
    RAISE EXCEPTION 'shared profile requires reviewed existing Supabase PostgreSQL 17 baseline';
  END IF;
  -- Consistent lock order with Auth provisioning; protects baseline capture.
  LOCK TABLE auth.users IN ACCESS EXCLUSIVE MODE;
  LOCK TABLE public.users IN ACCESS EXCLUSIVE MODE;
  IF pg_catalog.to_regnamespace('idealab_private') IS NOT NULL
    OR pg_catalog.to_regclass('public.users_college_roll_normalized_v1_uidx') IS NOT NULL
    OR EXISTS(SELECT 1 FROM pg_catalog.pg_proc p JOIN pg_catalog.pg_namespace n ON n.oid=p.pronamespace
      WHERE n.nspname='public' AND p.proname IN
        ('get_own_profile_v1','save_own_profile_v1','claim_mec_registration_v1')) THEN
    RAISE EXCEPTION 'private namespace or own-profile API already exists; reconcile instead of replacing';
  END IF;
  IF (SELECT count(*) FROM pg_catalog.pg_attribute
      WHERE attrelid='public.users'::regclass AND attnum>0 AND NOT attisdropped) <> 19
    OR EXISTS(SELECT 1 FROM public.users WHERE role NOT IN ('student','lab_admin','super_admin'))
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_constraint WHERE conrelid='public.users'::regclass
      AND conname='users_id_fkey' AND confrelid='auth.users'::regclass AND confdeltype='c')
    OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_constraint WHERE conrelid='public.users'::regclass
      AND conname='users_college_roll_key' AND contype='u') THEN
    RAISE EXCEPTION 'users shape/identity/role/unique baseline requires reconciliation';
  END IF;
  IF EXISTS(SELECT 1 FROM pg_catalog.pg_trigger WHERE tgrelid IN ('auth.users'::regclass,'public.users'::regclass) AND NOT tgisinternal)
    OR (SELECT count(*) FROM pg_catalog.pg_policies WHERE schemaname='public' AND tablename='users')<>4
    OR EXISTS(SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname='public' AND tablename='users'
      AND policyname NOT IN ('users_select_own','users_update_own','users_insert_own','users_read_all')) THEN
    RAISE EXCEPTION 'Auth trigger/account-policy baseline changed; review interactions';
  END IF;
  IF NOT pg_catalog.has_table_privilege(current_user,'auth.users','TRIGGER')
    OR NOT pg_catalog.has_schema_privilege(current_user,'auth','USAGE') THEN
    RAISE EXCEPTION 'existing maintenance Auth privilege chain is insufficient';
  END IF;
  -- Management API/Data API exposed-schema allowlist must be separately verified:
  -- idealab_private must not be exposed. No unverified GUC is used as proof.

  -- Private persisted rollback evidence, captured before any contract DDL.
  -- Hashes are comparison-only, not backups; no credential/session fields read.
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
  SELECT jsonb_build_object(
      'format','shared-profile-persisted-pristine-rollback-v1',
      'provenance','shared-profile-contract-v1-reviewed-preinstall',
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
        WHERE c.attrelid='public.users'::regclass AND c.attnum>0 AND NOT c.attisdropped),'[]'::jsonb)) INTO v_original_baseline;

  ALTER TABLE public.users
    ADD COLUMN institution text,
    ADD COLUMN department text,
    ADD COLUMN study_year smallint,
    ADD COLUMN profile_contract_version smallint NOT NULL DEFAULT 0,
    ADD COLUMN profile_revision bigint NOT NULL DEFAULT 0,
    ADD CONSTRAINT users_study_year_v1_check CHECK(study_year BETWEEN 1 AND 8),
    ADD CONSTRAINT users_profile_contract_v1_check CHECK(profile_contract_version IN (0,1)),
    ADD CONSTRAINT users_profile_revision_v1_check CHECK(profile_revision>=0);
  -- Defaults mark unreconciled legacy accounts version 0; no trusted completion
  -- or admission is synthesized from their legacy boolean or role.

  CREATE SCHEMA idealab_private AUTHORIZATION postgres;
  REVOKE ALL ON SCHEMA idealab_private FROM PUBLIC,anon,authenticated,service_role;
  GRANT USAGE ON SCHEMA idealab_private TO authenticated;
  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA idealab_private
    REVOKE ALL ON TABLES FROM PUBLIC,anon,authenticated,service_role;
  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA idealab_private
    REVOKE ALL ON SEQUENCES FROM PUBLIC,anon,authenticated,service_role;
  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA idealab_private
    REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC,anon,authenticated,service_role;
  CREATE TABLE idealab_private.profile_contract_baseline_v1 (
    singleton boolean PRIMARY KEY DEFAULT true CHECK(singleton),
    snapshot jsonb NOT NULL
  );
  ALTER TABLE idealab_private.profile_contract_baseline_v1 OWNER TO postgres;
  ALTER TABLE idealab_private.profile_contract_baseline_v1 ENABLE ROW LEVEL SECURITY;
  ALTER TABLE idealab_private.profile_contract_baseline_v1 FORCE ROW LEVEL SECURITY;
  REVOKE ALL ON idealab_private.profile_contract_baseline_v1 FROM PUBLIC,anon,authenticated,service_role;
  INSERT INTO idealab_private.profile_contract_baseline_v1(snapshot) VALUES(v_original_baseline);
  -- No policy, function or API exposes this maintenance-only provenance record.
  CREATE COLLATION idealab_private.mec_registration_ci
    (provider=icu, locale='und-u-ks-level2', deterministic=false);
  IF EXISTS(SELECT 1 FROM pg_catalog.pg_collation
    WHERE oid='idealab_private.mec_registration_ci'::regcollation
      AND collversion IS DISTINCT FROM pg_catalog.pg_collation_actual_version(oid)) THEN
    RAISE EXCEPTION 'MEC comparison collation is stale';
  END IF;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.normalize_mec_registration_v1(p_display_value text)
RETURNS text
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
SET search_path = ''
AS $function$
  SELECT pg_catalog.btrim(
    pg_catalog.regexp_replace(p_display_value, '[[:space:]]+', ' ', 'g')
  );
$function$;
  $ddl$;

  -- Same transaction and users lock as the whole cutover. A collision aborts
  -- all preceding DDL and returns no account/registration/constraint details.
  IF EXISTS(SELECT 1 FROM public.users WHERE college_roll IS NOT NULL
    GROUP BY idealab_private.normalize_mec_registration_v1(college_roll)
      COLLATE idealab_private.mec_registration_ci
    HAVING pg_catalog.count(*)>1) THEN
    RAISE EXCEPTION 'legacy registration comparison conflict; reconcile before rollout';
  END IF;
  CREATE UNIQUE INDEX users_college_roll_normalized_v1_uidx ON public.users
    (idealab_private.normalize_mec_registration_v1(college_roll)
      COLLATE idealab_private.mec_registration_ci)
    WHERE college_roll IS NOT NULL;

CREATE TABLE idealab_private.mec_registration_claims_v1 (
  claim_id uuid PRIMARY KEY DEFAULT pg_catalog.gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_value text NOT NULL,
  normalized_value text COLLATE idealab_private.mec_registration_ci
    GENERATED ALWAYS AS (
      idealab_private.normalize_mec_registration_v1(display_value)
    ) STORED,
  claim_state text NOT NULL CHECK (claim_state IN ('current', 'pending')),
  attested_at timestamptz NOT NULL,
  attestation_version integer NOT NULL CHECK (attestation_version > 0),
  created_at timestamptz NOT NULL DEFAULT pg_catalog.clock_timestamp(),
  CONSTRAINT mec_registration_claims_v1_nonempty_display
    CHECK (
      idealab_private.normalize_mec_registration_v1(display_value) <> ''
    )
);

CREATE UNIQUE INDEX mec_registration_claims_v1_normalized_uidx
  ON idealab_private.mec_registration_claims_v1 (normalized_value);
CREATE UNIQUE INDEX mec_registration_claims_v1_one_current_per_user_uidx
  ON idealab_private.mec_registration_claims_v1 (user_id)
  WHERE claim_state = 'current';
CREATE UNIQUE INDEX mec_registration_claims_v1_one_pending_per_user_uidx
  ON idealab_private.mec_registration_claims_v1 (user_id)
  WHERE claim_state = 'pending';

ALTER TABLE idealab_private.mec_registration_claims_v1 ENABLE ROW LEVEL SECURITY;
ALTER TABLE idealab_private.mec_registration_claims_v1 FORCE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE idealab_private.mec_registration_claims_v1
  FROM PUBLIC, anon, authenticated;


  CREATE TABLE idealab_private.mec_registration_collision_state_v1 (
    user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    collision_times timestamptz[] NOT NULL,
    CONSTRAINT mec_collision_bound_v1 CHECK (pg_catalog.cardinality(collision_times) BETWEEN 1 AND 5),
    CONSTRAINT mec_collision_no_null_v1 CHECK (pg_catalog.array_position(collision_times, NULL::timestamptz) IS NULL)
  );
  ALTER TABLE idealab_private.mec_registration_collision_state_v1 ENABLE ROW LEVEL SECURITY;
  ALTER TABLE idealab_private.mec_registration_collision_state_v1 FORCE ROW LEVEL SECURITY;
  REVOKE ALL ON TABLE idealab_private.mec_registration_collision_state_v1 FROM PUBLIC, anon, authenticated, service_role;
  REVOKE SELECT (user_id, collision_times), INSERT (user_id, collision_times),
    UPDATE (user_id, collision_times), REFERENCES (user_id, collision_times)
    ON idealab_private.mec_registration_collision_state_v1 FROM PUBLIC, anon, authenticated, service_role;


  EXECUTE $ddl$
CREATE FUNCTION idealab_private.has_current_verified_email_v1()
    RETURNS boolean
    LANGUAGE sql
    STABLE
    SECURITY DEFINER
    SET search_path = ''
    AS $identity$
      SELECT EXISTS (
        SELECT 1
        FROM auth.users AS identity_row
        WHERE identity_row.id = (SELECT auth.uid())
          AND identity_row.is_anonymous IS FALSE
          AND identity_row.email IS NOT NULL
          AND pg_catalog.btrim(identity_row.email) <> ''
          AND identity_row.email_confirmed_at IS NOT NULL
      );
    $identity$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.validate_required_profile_v1(p_profile jsonb, p_contract_version smallint)
    RETURNS TABLE (valid boolean, normalized jsonb, complete boolean)
    LANGUAGE plpgsql IMMUTABLE SECURITY INVOKER SET search_path = ''
    AS $validate$
    DECLARE
      v_key text;
      v_text text;
      v_normalized jsonb := '{}'::jsonb;
      v_complete boolean;
    BEGIN
      IF p_contract_version IS NULL OR p_contract_version NOT IN (0, 1)
        OR pg_catalog.jsonb_typeof(p_profile) IS DISTINCT FROM 'object' THEN
        RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
      END IF;
      IF (SELECT pg_catalog.count(*) FROM pg_catalog.jsonb_object_keys(p_profile)) <> 6
        OR NOT (p_profile ?& ARRAY['name', 'phone', 'college_roll', 'institution', 'department', 'study_year']) THEN
        RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
      END IF;
      FOREACH v_key IN ARRAY ARRAY['name', 'phone', 'college_roll', 'institution', 'department'] LOOP
        IF pg_catalog.jsonb_typeof(p_profile -> v_key) = 'null' AND v_key <> 'name' THEN
          v_normalized := v_normalized || pg_catalog.jsonb_build_object(v_key, NULL::text);
          CONTINUE;
        END IF;
        IF pg_catalog.jsonb_typeof(p_profile -> v_key) IS DISTINCT FROM 'string' THEN
          RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
        END IF;
        v_text := p_profile ->> v_key;
        IF pg_catalog.char_length(v_text)>4096 OR v_text ~ '[[:cntrl:]]' THEN
          RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
        END IF;
        IF v_key = 'college_roll' THEN
          -- Normalize for validation/comparison, but preserve nonempty display.
          IF pg_catalog.char_length(idealab_private.normalize_mec_registration_v1(v_text)) > 64 THEN
            RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
          END IF;
          IF idealab_private.normalize_mec_registration_v1(v_text) = '' THEN v_text := NULL; END IF;
        ELSE
          v_text := pg_catalog.regexp_replace(v_text, '^[[:space:]]+|[[:space:]]+$', '', 'g');
          IF v_key <> 'name' AND v_text = '' THEN v_text := NULL; END IF;
          IF (v_key IN ('name', 'department') AND pg_catalog.char_length(v_text) > 120)
            OR (v_key = 'institution' AND (pg_catalog.char_length(v_text) > 200 OR v_text <> 'Model Engineering College'))
            OR (v_key = 'phone' AND v_text !~ '^[+][1-9][0-9]{1,14}$') THEN
            RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
          END IF;
        END IF;
        v_normalized := v_normalized || pg_catalog.jsonb_build_object(v_key, v_text);
      END LOOP;
      IF pg_catalog.jsonb_typeof(p_profile -> 'study_year') = 'null' THEN
        v_normalized := v_normalized || '{"study_year":null}'::jsonb;
      ELSIF pg_catalog.jsonb_typeof(p_profile -> 'study_year') = 'number'
        AND (p_profile ->> 'study_year') ~ '^[1-8]$' THEN
        v_normalized := v_normalized || pg_catalog.jsonb_build_object('study_year', (p_profile ->> 'study_year')::smallint);
      ELSE
        RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
      END IF;
      v_complete := (v_normalized ->> 'name') <> ''
        AND (v_normalized ->> 'phone') IS NOT NULL AND (v_normalized ->> 'college_roll') IS NOT NULL
        AND (v_normalized ->> 'institution') IS NOT NULL AND (v_normalized ->> 'department') IS NOT NULL
        AND (v_normalized ->> 'study_year') IS NOT NULL;
      IF p_contract_version = 1 AND NOT v_complete THEN
        RETURN QUERY SELECT false, NULL::jsonb, false; RETURN;
      END IF;
      RETURN QUERY SELECT true, v_normalized, v_complete;
    END;
    $validate$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.current_student_mec_admitted_v1()
    RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = ''
    AS $admission$
      SELECT EXISTS (
        SELECT 1 FROM public.users AS u
        JOIN idealab_private.mec_registration_claims_v1 AS c ON c.user_id = u.id
        WHERE u.id = (SELECT auth.uid())
          AND (SELECT idealab_private.has_current_verified_email_v1())
          AND u.role = 'student' AND u.is_active IS TRUE
          AND u.profile_contract_version = 1 AND u.profile_completed IS TRUE
          AND pg_catalog.char_length(pg_catalog.regexp_replace(u.name,
            '^[[:space:]]+|[[:space:]]+$', '', 'g')) BETWEEN 1 AND 120
          AND u.name !~ '[[:cntrl:]]'
          AND u.phone ~ '^[+][1-9][0-9]{1,14}$'
          AND u.phone !~ '[[:cntrl:]]'
          AND pg_catalog.char_length(idealab_private.normalize_mec_registration_v1(u.college_roll)) BETWEEN 1 AND 64
          AND u.college_roll !~ '[[:cntrl:]]'
          AND u.institution = 'Model Engineering College'
          AND pg_catalog.char_length(u.institution) BETWEEN 1 AND 200
          AND pg_catalog.char_length(pg_catalog.regexp_replace(u.department,
            '^[[:space:]]+|[[:space:]]+$', '', 'g')) BETWEEN 1 AND 120
          AND u.department !~ '[[:cntrl:]]'
          AND u.study_year BETWEEN 1 AND 8
          AND c.claim_state = 'current' AND c.attestation_version = 1
          AND c.attested_at IS NOT NULL AND c.attested_at <= pg_catalog.statement_timestamp()
          AND pg_catalog.char_length(idealab_private.normalize_mec_registration_v1(c.display_value)) BETWEEN 1 AND 64
          AND c.display_value !~ '[[:cntrl:]]'
          AND c.normalized_value = idealab_private.normalize_mec_registration_v1(u.college_roll)
            COLLATE idealab_private.mec_registration_ci
      );
    $admission$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.save_current_profile_v1(p_profile jsonb, p_expected_revision text)
    RETURNS TABLE (status text, profile_revision text)
    LANGUAGE plpgsql VOLATILE SECURITY DEFINER SET search_path = ''
    AS $save$
    DECLARE
      v_uid uuid := auth.uid();
      v_user public.users%ROWTYPE;
      v_valid record;
      v_now timestamptz;
      v_times timestamptz[];
      v_changed_roll boolean;
      v_constraint text;
      v_next bigint;
    BEGIN
      IF v_uid IS NULL OR NOT idealab_private.has_current_verified_email_v1() THEN
        RETURN QUERY SELECT 'verification_required'::text, NULL::text; RETURN;
      END IF;
      SELECT u.* INTO v_user FROM public.users AS u WHERE u.id = v_uid FOR UPDATE;
      IF NOT FOUND THEN RETURN QUERY SELECT 'unavailable'::text, NULL::text; RETURN; END IF;
      v_now := pg_catalog.clock_timestamp(); -- capture AFTER any own-row lock wait
      IF v_user.is_active IS DISTINCT FROM true THEN
        RETURN QUERY SELECT 'inactive'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF v_user.profile_contract_version IS NULL OR v_user.profile_contract_version NOT IN (0, 1)
        OR v_user.profile_revision IS NULL OR v_user.profile_revision < 0 THEN
        RETURN QUERY SELECT 'unavailable'::text, NULL::text; RETURN;
      END IF;
      IF p_expected_revision IS NULL OR p_expected_revision !~ '^(0|[1-9][0-9]{0,18})$'
        OR p_expected_revision ~ '[^0-9]' THEN
        RETURN QUERY SELECT 'invalid'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF p_expected_revision::numeric > 9223372036854775807 THEN
        RETURN QUERY SELECT 'invalid'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF p_expected_revision::bigint <> v_user.profile_revision THEN
        RETURN QUERY SELECT 'conflict'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF v_user.profile_revision = 9223372036854775807 THEN
        RETURN QUERY SELECT 'unavailable'::text, v_user.profile_revision::text; RETURN;
      END IF;
      SELECT * INTO v_valid FROM idealab_private.validate_required_profile_v1(p_profile, v_user.profile_contract_version);
      IF NOT v_valid.valid THEN
        RETURN QUERY SELECT 'invalid'::text, v_user.profile_revision::text; RETURN;
      END IF;
      v_changed_roll := (v_valid.normalized ->> 'college_roll') IS DISTINCT FROM v_user.college_roll;
      IF v_changed_roll AND EXISTS (SELECT 1 FROM idealab_private.mec_registration_claims_v1 AS c
                                    WHERE c.user_id = v_uid AND c.claim_state = 'current') THEN
        RETURN QUERY SELECT 'claim_transition_required'::text, v_user.profile_revision::text; RETURN;
      END IF;
      SELECT COALESCE(pg_catalog.array_agg(t.at ORDER BY t.at), ARRAY[]::timestamptz[]) INTO v_times
      FROM idealab_private.mec_registration_collision_state_v1 AS s
      CROSS JOIN LATERAL pg_catalog.unnest(s.collision_times) AS t(at)
      WHERE s.user_id = v_uid AND t.at > v_now - interval '15 minutes';
      IF pg_catalog.cardinality(v_times) = 0 THEN
        DELETE FROM idealab_private.mec_registration_collision_state_v1 AS s WHERE s.user_id = v_uid;
      ELSE
        UPDATE idealab_private.mec_registration_collision_state_v1 AS s SET collision_times = v_times WHERE s.user_id = v_uid;
      END IF;
      IF v_changed_roll AND (v_valid.normalized ->> 'college_roll') IS NOT NULL
        AND pg_catalog.cardinality(v_times) >= 5 THEN
        RETURN QUERY SELECT 'not_saved'::text, v_user.profile_revision::text; RETURN;
      END IF;
      v_next := v_user.profile_revision + 1;
      BEGIN
        UPDATE public.users AS u SET
          name = v_valid.normalized ->> 'name', phone = v_valid.normalized ->> 'phone',
          college_roll = v_valid.normalized ->> 'college_roll', institution = v_valid.normalized ->> 'institution',
          department = v_valid.normalized ->> 'department', study_year = (v_valid.normalized ->> 'study_year')::smallint,
          profile_completed = v_valid.complete, profile_contract_version = CASE WHEN v_valid.complete THEN 1 ELSE 0 END,
          profile_revision = v_next, updated_at = pg_catalog.clock_timestamp()
        WHERE u.id = v_uid;
      EXCEPTION WHEN unique_violation THEN
        GET STACKED DIAGNOSTICS v_constraint = CONSTRAINT_NAME;
        IF v_constraint IN ('users_college_roll_key','users_college_roll_normalized_v1_uidx') AND v_changed_roll
          AND (v_valid.normalized ->> 'college_roll') IS NOT NULL THEN
          INSERT INTO idealab_private.mec_registration_collision_state_v1 AS s (user_id, collision_times)
          VALUES (v_uid, pg_catalog.array_append(v_times, v_now))
          ON CONFLICT (user_id) DO UPDATE SET collision_times = EXCLUDED.collision_times;
        END IF;
        RETURN QUERY SELECT 'not_saved'::text, v_user.profile_revision::text; RETURN;
      END;
      RETURN QUERY SELECT 'saved'::text, v_next::text;
    END;
    $save$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION public.save_own_profile_v1(p_profile jsonb, p_expected_revision text)
    RETURNS TABLE (status text, profile_revision text)
    LANGUAGE sql VOLATILE SECURITY INVOKER SET search_path = ''
    AS $wrapper$
      SELECT result.status, result.profile_revision
      FROM idealab_private.save_current_profile_v1(p_profile, p_expected_revision) AS result;
    $wrapper$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.validate_mec_claim_display_v1(p_display_number text)
    RETURNS boolean LANGUAGE sql IMMUTABLE SECURITY INVOKER SET search_path = ''
    AS $validate$
      SELECT CASE WHEN p_display_number IS NULL
        OR pg_catalog.char_length(p_display_number) > 4096 THEN false
      ELSE COALESCE(
        pg_catalog.char_length(idealab_private.normalize_mec_registration_v1(p_display_number)) BETWEEN 1 AND 64
        AND p_display_number !~ '[[:cntrl:]]'
        AND idealab_private.normalize_mec_registration_v1(p_display_number) ~* '^(LMDL|MDL)', false) END;
    $validate$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.claim_current_mec_registration_v1(
      p_display_number text, p_expected_revision text, p_self_declaration boolean)
    RETURNS TABLE (status text, profile_revision text)
    LANGUAGE plpgsql VOLATILE SECURITY DEFINER SET search_path = ''
    AS $claim$
    DECLARE
      v_uid uuid := auth.uid();
      v_user public.users%ROWTYPE;
      v_current idealab_private.mec_registration_claims_v1%ROWTYPE;
      v_has_current boolean;
      v_valid record;
      v_now timestamptz;
      v_times timestamptz[];
      v_same_normalized boolean := false;
      v_collision boolean := false;
      v_constraint text;
      v_pending_id uuid;
      v_next bigint;
    BEGIN
      IF v_uid IS NULL OR NOT idealab_private.has_current_verified_email_v1() THEN
        RETURN QUERY SELECT 'verification_required'::text, NULL::text; RETURN;
      END IF;
      SELECT u.* INTO v_user FROM public.users AS u WHERE u.id = v_uid FOR UPDATE;
      IF NOT FOUND THEN RETURN QUERY SELECT 'unavailable'::text, NULL::text; RETURN; END IF;
      v_now := pg_catalog.clock_timestamp();
      IF v_user.is_active IS DISTINCT FROM true THEN
        RETURN QUERY SELECT 'inactive'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF v_user.role IS DISTINCT FROM 'student'
        OR v_user.profile_contract_version IS NULL OR v_user.profile_contract_version NOT IN (0, 1)
        OR v_user.profile_revision IS NULL OR v_user.profile_revision < 0 THEN
        RETURN QUERY SELECT 'unavailable'::text, NULL::text; RETURN;
      END IF;
      IF p_expected_revision IS NULL OR p_expected_revision !~ '^(0|[1-9][0-9]{0,18})$'
        OR p_expected_revision ~ '[^0-9]' THEN
        RETURN QUERY SELECT 'invalid'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF p_expected_revision::numeric > 9223372036854775807
        OR p_self_declaration IS DISTINCT FROM true
        OR NOT idealab_private.validate_mec_claim_display_v1(p_display_number) THEN
        RETURN QUERY SELECT 'invalid'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF v_user.profile_contract_version <> 1 OR v_user.profile_completed IS DISTINCT FROM true
        OR v_user.institution IS DISTINCT FROM 'Model Engineering College' THEN
        RETURN QUERY SELECT 'profile_required'::text, v_user.profile_revision::text; RETURN;
      END IF;
      SELECT * INTO v_valid FROM idealab_private.validate_required_profile_v1(pg_catalog.jsonb_build_object(
        'name', v_user.name, 'phone', v_user.phone, 'college_roll', v_user.college_roll,
        'institution', v_user.institution, 'department', v_user.department, 'study_year', v_user.study_year), 1::smallint);
      IF NOT v_valid.valid OR NOT v_valid.complete THEN
        RETURN QUERY SELECT 'profile_required'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF EXISTS (SELECT 1 FROM idealab_private.mec_registration_claims_v1 AS c
                  WHERE c.user_id = v_uid AND c.claim_state = 'pending') THEN
        RETURN QUERY SELECT 'unavailable'::text, v_user.profile_revision::text; RETURN;
      END IF;
      SELECT c.* INTO v_current FROM idealab_private.mec_registration_claims_v1 AS c
        WHERE c.user_id = v_uid AND c.claim_state = 'current';
      v_has_current := FOUND;
      IF v_has_current THEN
        IF v_current.attestation_version <> 1 OR v_current.attested_at IS NULL OR v_current.attested_at > v_now
          OR NOT idealab_private.validate_mec_claim_display_v1(v_current.display_value)
          OR v_current.normalized_value IS DISTINCT FROM
            idealab_private.normalize_mec_registration_v1(v_user.college_roll) COLLATE idealab_private.mec_registration_ci THEN
          RETURN QUERY SELECT 'unavailable'::text, v_user.profile_revision::text; RETURN;
        END IF;
        v_same_normalized := v_current.normalized_value =
          idealab_private.normalize_mec_registration_v1(p_display_number) COLLATE idealab_private.mec_registration_ci;
        IF v_same_normalized AND v_current.display_value = p_display_number AND v_user.college_roll = p_display_number THEN
          -- Narrow lost-response retry exception: all authority/profile/claim
          -- checks and revision representation validation already passed.
          RETURN QUERY SELECT 'claimed'::text, v_user.profile_revision::text; RETURN;
        END IF;
      END IF;
      IF p_expected_revision::bigint <> v_user.profile_revision THEN
        RETURN QUERY SELECT 'conflict'::text, v_user.profile_revision::text; RETURN;
      END IF;
      IF v_user.profile_revision = 9223372036854775807 THEN
        RETURN QUERY SELECT 'unavailable'::text, v_user.profile_revision::text; RETURN;
      END IF;
      SELECT COALESCE(pg_catalog.array_agg(t.at ORDER BY t.at), ARRAY[]::timestamptz[]) INTO v_times
      FROM idealab_private.mec_registration_collision_state_v1 AS s
      CROSS JOIN LATERAL pg_catalog.unnest(s.collision_times) AS t(at)
      WHERE s.user_id = v_uid AND t.at > v_now - interval '15 minutes';
      IF pg_catalog.cardinality(v_times) = 0 THEN
        DELETE FROM idealab_private.mec_registration_collision_state_v1 AS s WHERE s.user_id = v_uid;
      ELSE
        UPDATE idealab_private.mec_registration_collision_state_v1 AS s SET collision_times = v_times WHERE s.user_id = v_uid;
      END IF;
      IF pg_catalog.cardinality(v_times) >= 5 THEN
        RETURN QUERY SELECT 'not_claimed'::text, v_user.profile_revision::text; RETURN;
      END IF;
      v_next := v_user.profile_revision + 1;
      BEGIN
        IF v_same_normalized THEN
          UPDATE idealab_private.mec_registration_claims_v1 AS c SET display_value = p_display_number
            WHERE c.claim_id = v_current.claim_id AND c.user_id = v_uid AND c.claim_state = 'current';
        ELSE
          INSERT INTO idealab_private.mec_registration_claims_v1
            (user_id, display_value, claim_state, attested_at, attestation_version)
          VALUES (v_uid, p_display_number, 'pending', v_now, 1)
          ON CONFLICT (normalized_value) DO NOTHING RETURNING claim_id INTO v_pending_id;
          IF NOT FOUND THEN
            v_collision := true;
          ELSE
            IF v_has_current THEN
              DELETE FROM idealab_private.mec_registration_claims_v1 AS c
                WHERE c.claim_id = v_current.claim_id AND c.user_id = v_uid AND c.claim_state = 'current';
            END IF;
            UPDATE idealab_private.mec_registration_claims_v1 AS c SET claim_state = 'current'
              WHERE c.claim_id = v_pending_id AND c.user_id = v_uid AND c.claim_state = 'pending';
          END IF;
        END IF;
        IF NOT v_collision THEN
          UPDATE public.users AS u SET college_roll = p_display_number, profile_revision = v_next, updated_at = pg_catalog.clock_timestamp() WHERE u.id = v_uid;
        END IF;
      EXCEPTION WHEN unique_violation THEN
        GET STACKED DIAGNOSTICS v_constraint = CONSTRAINT_NAME;
        IF v_constraint IN ('users_college_roll_key', 'users_college_roll_normalized_v1_uidx',
          'mec_registration_claims_v1_normalized_uidx') THEN
          v_collision := true;
        ELSE
          RETURN QUERY SELECT 'not_claimed'::text, v_user.profile_revision::text; RETURN;
        END IF;
      WHEN check_violation THEN
        -- Includes a caller-forced IMMEDIATE pending guard. The entire inner
        -- swap is rolled back before returning; no occupied-number inference.
        RETURN QUERY SELECT 'not_claimed'::text, v_user.profile_revision::text; RETURN;
      END;
      IF v_collision THEN
        INSERT INTO idealab_private.mec_registration_collision_state_v1 (user_id, collision_times)
          VALUES (v_uid, pg_catalog.array_append(v_times, v_now))
          ON CONFLICT (user_id) DO UPDATE SET collision_times = EXCLUDED.collision_times;
        RETURN QUERY SELECT 'not_claimed'::text, v_user.profile_revision::text; RETURN;
      END IF;
      RETURN QUERY SELECT 'claimed'::text, v_next::text;
    END;
    $claim$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION public.claim_mec_registration_v1(
      p_display_number text, p_expected_revision text, p_self_declaration boolean)
    RETURNS TABLE (status text, profile_revision text)
    LANGUAGE sql VOLATILE SECURITY INVOKER SET search_path = ''
    AS $wrapper$
      SELECT result.status, result.profile_revision FROM idealab_private.claim_current_mec_registration_v1(
        p_display_number, p_expected_revision, p_self_declaration) AS result;
    $wrapper$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.enforce_no_committed_pending_mec_claim_v1()
    RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
    AS $guard$
    BEGIN
      IF TG_TABLE_SCHEMA <> 'idealab_private'
        OR TG_TABLE_NAME <> 'mec_registration_claims_v1'
        OR TG_NAME <> 'mec_registration_claims_v1_no_pending_at_commit'
        OR TG_LEVEL <> 'ROW' OR TG_WHEN <> 'AFTER'
        OR TG_OP NOT IN ('INSERT','UPDATE') THEN
        RAISE EXCEPTION 'MEC claim commit guard requires its exact internal trigger';
      END IF;
      -- Deferred events can run after the caller-scoped definer RPC returns.
      -- Read only this fixed private table as its owner; never grant client
      -- SELECT and never interpret the trigger attachment as a table name.
      IF EXISTS (SELECT 1 FROM idealab_private.mec_registration_claims_v1 c
                 WHERE c.claim_id=NEW.claim_id AND c.claim_state='pending') THEN
        RAISE EXCEPTION USING ERRCODE='23514',
          MESSAGE='pending MEC registration claim cannot remain at transaction end';
      END IF;
      RETURN NEW;
    END;
    $guard$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.ensure_current_profile_v1()
RETURNS void LANGUAGE plpgsql VOLATILE SECURITY DEFINER SET search_path=''
AS $ensure$
DECLARE v_uid uuid:=auth.uid(); v_email text;
BEGIN
  IF v_uid IS NULL OR NOT idealab_private.has_current_verified_email_v1() THEN RETURN; END IF;
  SELECT email INTO v_email FROM auth.users WHERE id=v_uid;
  INSERT INTO public.users(id,name,email,role,is_active,profile_completed,profile_contract_version,profile_revision)
  VALUES(v_uid,'',v_email,'student',true,false,0,0) ON CONFLICT(id) DO NOTHING;
EXCEPTION WHEN unique_violation THEN
  -- No address/constraint details or other account identifiers are returned.
  RETURN;
END;
$ensure$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION public.get_own_profile_v1()
RETURNS TABLE(id uuid,name text,phone text,college_roll text,institution text,
 department text,study_year smallint,role text,is_active boolean,
 profile_completed boolean,profile_contract_version smallint,
 profile_revision text,mec_admitted boolean)
LANGUAGE plpgsql VOLATILE SECURITY DEFINER SET search_path=''
AS $read$
BEGIN
  IF auth.uid() IS NULL OR NOT idealab_private.has_current_verified_email_v1() THEN RETURN; END IF;
  PERFORM idealab_private.ensure_current_profile_v1();
  RETURN QUERY SELECT u.id,u.name,u.phone,u.college_roll,u.institution,
    u.department,u.study_year,u.role,u.is_active,
    (u.profile_contract_version=1 AND u.profile_completed IS TRUE),
    u.profile_contract_version,u.profile_revision::text,
    idealab_private.current_student_mec_admitted_v1()
  FROM public.users u WHERE u.id=(SELECT auth.uid());
END;
$read$;
  $ddl$;

  EXECUTE $ddl$
CREATE FUNCTION idealab_private.provision_shared_profile_v1()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=''
AS $provision$
BEGIN
  IF TG_TABLE_SCHEMA<>'auth' OR TG_TABLE_NAME<>'users'
    OR TG_NAME NOT IN ('shared_profile_after_auth_insert_v1','shared_profile_after_auth_update_v1')
    OR TG_LEVEL<>'ROW' OR TG_WHEN<>'AFTER' OR TG_OP NOT IN ('INSERT','UPDATE') THEN
    RAISE EXCEPTION 'shared provisioning requires its exact Auth trigger';
  END IF;
  IF NEW.is_anonymous IS DISTINCT FROM false OR NEW.email_confirmed_at IS NULL
    OR NEW.email IS NULL OR pg_catalog.btrim(NEW.email)='' THEN RETURN NEW; END IF;
  INSERT INTO public.users(id,name,email,role,is_active,profile_completed,profile_contract_version,profile_revision)
  VALUES(NEW.id,'',NEW.email,'student',true,false,0,0) ON CONFLICT(id) DO NOTHING;
  -- Identity synchronization only. No profile revision, editable field, role,
  -- completion, ban flag or admission is inferred from Auth metadata.
  UPDATE public.users SET email=NEW.email WHERE id=NEW.id AND email IS DISTINCT FROM NEW.email;
  RETURN NEW;
END;
$provision$;
  $ddl$;


  CREATE CONSTRAINT TRIGGER mec_registration_claims_v1_no_pending_at_commit
    AFTER INSERT OR UPDATE OF claim_state ON idealab_private.mec_registration_claims_v1
    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
    EXECUTE FUNCTION idealab_private.enforce_no_committed_pending_mec_claim_v1();
  CREATE TRIGGER shared_profile_after_auth_insert_v1 AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION idealab_private.provision_shared_profile_v1();
  CREATE TRIGGER shared_profile_after_auth_update_v1
    AFTER UPDATE OF email,email_confirmed_at,is_anonymous ON auth.users
    FOR EACH ROW EXECUTE FUNCTION idealab_private.provision_shared_profile_v1();

  ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.users FORCE ROW LEVEL SECURITY;
  DROP POLICY users_read_all ON public.users;
  DROP POLICY users_select_own ON public.users;
  DROP POLICY users_insert_own ON public.users;
  DROP POLICY users_update_own ON public.users;
  CREATE POLICY users_verified_owner_read_v1 ON public.users FOR SELECT TO authenticated
    USING(id=(SELECT auth.uid()) AND (SELECT idealab_private.has_current_verified_email_v1()));
  REVOKE ALL ON public.users FROM PUBLIC,anon,authenticated;
  FOR v_column IN SELECT attname FROM pg_catalog.pg_attribute
      WHERE attrelid='public.users'::regclass AND attnum>0 AND NOT attisdropped LOOP
    EXECUTE pg_catalog.format(
      'REVOKE SELECT(%1$I),INSERT(%1$I),UPDATE(%1$I),REFERENCES(%1$I) ON public.users FROM PUBLIC,anon,authenticated',
      v_column.attname);
  END LOOP;
  GRANT SELECT(id,name,phone,college_roll,institution,department,study_year,role,
    is_active,profile_completed,profile_contract_version,profile_revision)
    ON public.users TO authenticated;

  REVOKE ALL ON ALL TABLES IN SCHEMA idealab_private FROM PUBLIC,anon,authenticated,service_role;
  REVOKE ALL ON ALL FUNCTIONS IN SCHEMA idealab_private FROM PUBLIC,anon,authenticated,service_role;
  -- Trusted service-role DML maintains the users expression index. Grant only
  -- its pure normalizer; private schema/table and identity helper access stay denied.
  GRANT EXECUTE ON FUNCTION idealab_private.normalize_mec_registration_v1(text) TO service_role;
  GRANT EXECUTE ON FUNCTION idealab_private.has_current_verified_email_v1(),
    idealab_private.current_student_mec_admitted_v1(),
    idealab_private.save_current_profile_v1(jsonb,text),
    idealab_private.claim_current_mec_registration_v1(text,text,boolean) TO authenticated;
  REVOKE ALL ON FUNCTION public.get_own_profile_v1(),public.save_own_profile_v1(jsonb,text),
    public.claim_mec_registration_v1(text,text,boolean) FROM PUBLIC,anon,authenticated,service_role;
  GRANT EXECUTE ON FUNCTION public.get_own_profile_v1(),public.save_own_profile_v1(jsonb,text),
    public.claim_mec_registration_v1(text,text,boolean) TO authenticated;

  FOREACH v_role IN ARRAY ARRAY['anon','authenticated'] LOOP
    IF pg_catalog.has_table_privilege(v_role,'public.users','SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER,MAINTAIN') THEN
      RAISE EXCEPTION 'inherited full-account table privilege survives for API role %',v_role;
    END IF;
    FOR v_column IN SELECT attname FROM pg_catalog.pg_attribute
      WHERE attrelid='public.users'::regclass AND attnum>0 AND NOT attisdropped LOOP
      IF pg_catalog.has_column_privilege(v_role,'public.users',v_column.attname,'INSERT,UPDATE,REFERENCES')
        OR (pg_catalog.has_column_privilege(v_role,'public.users',v_column.attname,'SELECT')
          IS DISTINCT FROM (v_role='authenticated' AND v_column.attname=ANY(ARRAY[
            'id','name','phone','college_roll','institution','department','study_year','role',
            'is_active','profile_completed','profile_contract_version','profile_revision']))) THEN
        RAISE EXCEPTION 'unexpected effective account column privilege for API role %',v_role;
      END IF;
    END LOOP;
  END LOOP;
END;
$shared_profile_candidate$;
