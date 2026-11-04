-- SYNTHETIC LOCAL FIXTURE CHECKS ONLY — NOT FOR LIVE GROW OR VALIDATION.
-- Caller must BEGIN on its disposable Supabase-faithful PostgreSQL 17 cluster,
-- create the three exact synthetic verified Student fixtures BEFORE applying
-- shared_profile_contract_v1.sql, set the four GUCs below, run ordinary candidate
-- checks, then this file, and ROLLBACK. These guards prevent accidental targeting;
-- they are not an authorization boundary against a privileged administrator.
--
-- idealab.sql_fixture_only = 'true'
-- idealab.test_legacy_uid = '00000000-0000-4000-8000-000000000001'
-- idealab.test_other_uid  = '00000000-0000-4000-8000-000000000002'
-- idealab.test_claim_uid  = '00000000-0000-4000-8000-000000000003'
-- Legacy identity email is legacy@example.invalid and its preserved raw number
-- is ' MDL00TS001 '. Other/claim fixture emails must end in .invalid, with NULL
-- initial college_roll. All three must have contract version/revision zero,
-- role student, is_active true and no preexisting claims/collision state.
-- This file writes only these synthetic fixture accounts through public RPCs.
-- It does not test genuine Supabase Auth, email delivery or Flutter/browser IO.

DO $fixture_guard$
DECLARE
  v_expected uuid[] := ARRAY[
    '00000000-0000-4000-8000-000000000001'::uuid,
    '00000000-0000-4000-8000-000000000002'::uuid,
    '00000000-0000-4000-8000-000000000003'::uuid];
BEGIN
  IF current_user<>'postgres'
    OR current_setting('idealab.sql_fixture_only',true) IS DISTINCT FROM 'true'
    OR current_setting('idealab.test_legacy_uid',true) IS DISTINCT FROM v_expected[1]::text
    OR current_setting('idealab.test_other_uid',true) IS DISTINCT FROM v_expected[2]::text
    OR current_setting('idealab.test_claim_uid',true) IS DISTINCT FROM v_expected[3]::text THEN
    RAISE EXCEPTION 'synthetic local fixture marker/identity contract required before mutations';
  END IF;
  IF (SELECT count(*) FROM auth.users
    WHERE id=ANY(v_expected) AND email ~ '^[^@]+@[^@]+[.]invalid$'
      AND email_confirmed_at IS NOT NULL AND is_anonymous IS FALSE)<>3
    OR NOT EXISTS(SELECT 1 FROM auth.users WHERE id=v_expected[1] AND email='legacy@example.invalid')
    OR (SELECT count(*) FROM public.users WHERE id=ANY(v_expected)
      AND role='student' AND is_active IS TRUE
      AND profile_contract_version=0 AND profile_revision=0)<>3
    OR NOT EXISTS(SELECT 1 FROM public.users
      WHERE id=v_expected[1] AND college_roll=' MDL00TS001 ')
    OR EXISTS(SELECT 1 FROM public.users WHERE id=ANY(v_expected[2:3]) AND college_roll IS NOT NULL)
    OR EXISTS(SELECT 1 FROM idealab_private.mec_registration_claims_v1 WHERE user_id=ANY(v_expected))
    OR EXISTS(SELECT 1 FROM idealab_private.mec_registration_collision_state_v1 WHERE user_id=ANY(v_expected)) THEN
    RAISE EXCEPTION 'synthetic fixture state differs; no positive test mutation performed';
  END IF;
END;
$fixture_guard$;

DO $legacy_identity$
BEGIN
  PERFORM set_config('request.jwt.claim.sub',current_setting('idealab.test_legacy_uid'),true);
  PERFORM set_config('request.jwt.claims',jsonb_build_object(
    'sub',current_setting('idealab.test_legacy_uid'),'role','authenticated')::text,true);
END;
$legacy_identity$;
SET LOCAL ROLE authenticated;
DO $legacy_save$
DECLARE v_before record; v_result record; v_after record;
BEGIN
  SELECT * INTO v_before FROM public.get_own_profile_v1();
  IF NOT FOUND OR v_before.id::text<>current_setting('idealab.test_legacy_uid')
    OR v_before.college_roll IS DISTINCT FROM ' MDL00TS001 '
    OR v_before.profile_contract_version<>0 OR v_before.profile_completed IS DISTINCT FROM false
    OR v_before.mec_admitted IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'preserved legacy reservation became missing/completed/admitted';
  END IF;
  SELECT * INTO v_result FROM public.save_own_profile_v1(
    '{"name":"Synthetic Legacy Member","phone":"+919876543210","college_roll":" MDL00TS001 ","institution":"Model Engineering College","department":"Test Studies","study_year":2}',
    v_before.profile_revision);
  IF v_result.status IS DISTINCT FROM 'saved' OR v_result.profile_revision IS DISTINCT FROM '1' THEN
    RAISE EXCEPTION 'owner could not complete its preserved nonduplicate legacy reservation';
  END IF;
  SELECT * INTO v_after FROM public.get_own_profile_v1();
  IF NOT FOUND OR v_after.college_roll IS DISTINCT FROM ' MDL00TS001 '
    OR v_after.profile_contract_version<>1 OR v_after.profile_completed IS DISTINCT FROM true
    OR v_after.mec_admitted IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'legacy save changed display or synthesized declaration/admission';
  END IF;
END;
$legacy_save$;
RESET ROLE;

DO $other_identity$
BEGIN
  PERFORM set_config('request.jwt.claim.sub',current_setting('idealab.test_other_uid'),true);
  PERFORM set_config('request.jwt.claims',jsonb_build_object(
    'sub',current_setting('idealab.test_other_uid'),'role','authenticated')::text,true);
END;
$other_identity$;
SET LOCAL ROLE authenticated;
DO $normalized_save_conflict$
DECLARE v_result record; v_profile record;
BEGIN
  -- Different raw bytes: only the new normalized users index must reject this.
  SELECT * INTO v_result FROM public.save_own_profile_v1(
    '{"name":"Synthetic Other Member","phone":"+919876543211","college_roll":"mdl00ts001","institution":"Model Engineering College","department":"Test Studies","study_year":2}',
    '0');
  IF v_result.status IS DISTINCT FROM 'not_saved' OR v_result.profile_revision IS DISTINCT FROM '0'
    OR (SELECT count(*) FROM jsonb_object_keys(to_jsonb(v_result)))<>2 THEN
    RAISE EXCEPTION 'normalized save conflict did not return only the generic status/revision';
  END IF;
  SELECT * INTO v_profile FROM public.get_own_profile_v1();
  IF NOT FOUND OR v_profile.college_roll IS NOT NULL OR v_profile.profile_revision<>'0'
    OR v_profile.profile_contract_version<>0 OR v_profile.mec_admitted IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'normalized save conflict mutated the losing profile';
  END IF;
END;
$normalized_save_conflict$;
RESET ROLE;

DO $claim_identity$
BEGIN
  PERFORM set_config('request.jwt.claim.sub',current_setting('idealab.test_claim_uid'),true);
  PERFORM set_config('request.jwt.claims',jsonb_build_object(
    'sub',current_setting('idealab.test_claim_uid'),'role','authenticated')::text,true);
END;
$claim_identity$;
SET LOCAL ROLE authenticated;
DO $normalized_claim_conflict$
DECLARE v_result record; v_profile record;
BEGIN
  SELECT * INTO v_result FROM public.save_own_profile_v1(
    '{"name":"Synthetic Claim Member","phone":"+919876543212","college_roll":"MDL00TS003","institution":"Model Engineering College","department":"Test Studies","study_year":2}',
    '0');
  IF v_result.status IS DISTINCT FROM 'saved' OR v_result.profile_revision IS DISTINCT FROM '1' THEN
    RAISE EXCEPTION 'independent claim fixture profile could not be saved';
  END IF;
  -- No claim exists for the legacy number yet. The pending claim reservation
  -- must roll back when the normalized users index rejects its profile update.
  SELECT * INTO v_result FROM public.claim_mec_registration_v1('  mdL00Ts001  ','1',true);
  IF v_result.status IS DISTINCT FROM 'not_claimed' OR v_result.profile_revision IS DISTINCT FROM '1'
    OR (SELECT count(*) FROM jsonb_object_keys(to_jsonb(v_result)))<>2 THEN
    RAISE EXCEPTION 'normalized claim conflict did not return only generic status/revision';
  END IF;
  SELECT * INTO v_profile FROM public.get_own_profile_v1();
  IF NOT FOUND OR v_profile.college_roll IS DISTINCT FROM 'MDL00TS003'
    OR v_profile.profile_revision<>'1' OR v_profile.profile_completed IS DISTINCT FROM true
    OR v_profile.mec_admitted IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'normalized claim conflict failed to preserve the prior profile';
  END IF;
END;
$normalized_claim_conflict$;
RESET ROLE;

DO $collision_state$
BEGIN
  IF (SELECT cardinality(collision_times) FROM idealab_private.mec_registration_collision_state_v1
      WHERE user_id=current_setting('idealab.test_other_uid')::uuid) IS DISTINCT FROM 1
    OR (SELECT cardinality(collision_times) FROM idealab_private.mec_registration_collision_state_v1
      WHERE user_id=current_setting('idealab.test_claim_uid')::uuid) IS DISTINCT FROM 1
    OR EXISTS(SELECT 1 FROM idealab_private.mec_registration_claims_v1
      WHERE user_id IN(current_setting('idealab.test_legacy_uid')::uuid,
        current_setting('idealab.test_other_uid')::uuid,current_setting('idealab.test_claim_uid')::uuid)) THEN
    RAISE EXCEPTION 'normalized conflicts failed shared accounting or left a pending/current claim';
  END IF;
END;
$collision_state$;

DO $legacy_identity_again$
BEGIN
  PERFORM set_config('request.jwt.claim.sub',current_setting('idealab.test_legacy_uid'),true);
  PERFORM set_config('request.jwt.claims',jsonb_build_object(
    'sub',current_setting('idealab.test_legacy_uid'),'role','authenticated')::text,true);
END;
$legacy_identity_again$;
SET LOCAL ROLE authenticated;
DO $legacy_explicit_claim$
DECLARE v_result record; v_profile record;
BEGIN
  SELECT * INTO v_result FROM public.claim_mec_registration_v1(' MDL00TS001 ','1',true);
  IF v_result.status IS DISTINCT FROM 'claimed' OR v_result.profile_revision IS DISTINCT FROM '2' THEN
    RAISE EXCEPTION 'owner explicit declaration could not claim its preserved legacy reservation';
  END IF;
END;
$legacy_explicit_claim$;
-- A real RPC readback is a later statement. Admission's attestation time check
-- intentionally excludes claims timestamped after the current statement start.
DO $legacy_claim_readback$
DECLARE v_profile record;
BEGIN
  SELECT * INTO v_profile FROM public.get_own_profile_v1();
  IF NOT FOUND OR v_profile.college_roll IS DISTINCT FROM ' MDL00TS001 '
    OR v_profile.profile_revision<>'2' OR v_profile.mec_admitted IS DISTINCT FROM true THEN
    RAISE EXCEPTION 'explicit declaration/readback did not establish self-declared admission';
  END IF;
END;
$legacy_claim_readback$;
-- Flush the initially deferred guard after the caller-scoped RPC has returned,
-- while still authenticated, to exercise its fixed-target definer boundary.
SET CONSTRAINTS idealab_private.mec_registration_claims_v1_no_pending_at_commit IMMEDIATE;
SET CONSTRAINTS idealab_private.mec_registration_claims_v1_no_pending_at_commit DEFERRED;
RESET ROLE;

DO $final_claim_state$
BEGIN
  IF (SELECT count(*) FROM idealab_private.mec_registration_claims_v1
    WHERE user_id=current_setting('idealab.test_legacy_uid')::uuid
      AND claim_state='current' AND attestation_version=1)<>1
    OR EXISTS(SELECT 1 FROM idealab_private.mec_registration_claims_v1
      WHERE claim_state='pending'
        OR user_id IN(current_setting('idealab.test_other_uid')::uuid,current_setting('idealab.test_claim_uid')::uuid)) THEN
    RAISE EXCEPTION 'final synthetic claim-state invariants differ';
  END IF;
END;
$final_claim_state$;

SET LOCAL request.jwt.claims='{}';
SET LOCAL request.jwt.claim.sub='';
SELECT true AS synthetic_legacy_reservation_and_normalized_conflict_checks_passed;
-- Caller must ROLLBACK all fixture changes; no COMMIT is performed here.

