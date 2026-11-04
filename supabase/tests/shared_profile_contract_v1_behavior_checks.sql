-- LOCAL SYNTHETIC SQL BEHAVIOR ONLY. No genuine Auth/Data API/provider acceptance.
-- Execute only inside the disposable runner's rollback transaction.
SET LOCAL ROLE postgres;
DO $fixture_guard$
BEGIN
  IF current_setting('idealab.sql_fixture_only',true) IS DISTINCT FROM 'true'
    OR EXISTS(SELECT 1 FROM auth.users WHERE email IS NULL OR email !~ '@example[.]invalid$')
    OR NOT EXISTS(SELECT 1 FROM auth.users WHERE id='00000000-0000-4000-8000-000000000007'
      AND email='missing@example.invalid') THEN
    RAISE EXCEPTION 'behavior checks require exclusively synthetic disposable identities';
  END IF;
  IF EXISTS (
    SELECT 1 FROM shared_profile_fixture_original o JOIN public.users u USING(id)
    WHERE o.id IN ('00000000-0000-4000-8000-000000000005','00000000-0000-4000-8000-000000000006','00000000-0000-4000-8000-000000000009')
      AND (u.role,u.is_active,u.ban_reason,u.banned_at)
        IS DISTINCT FROM (o.role,o.is_active,o.ban_reason,o.banned_at)
  ) THEN RAISE EXCEPTION 'legacy authority/ban values changed'; END IF;
END $fixture_guard$;

SET LOCAL request.jwt.claims='{}';
SET LOCAL request.jwt.claim.sub='00000000-0000-4000-8000-000000000004';
SET LOCAL ROLE authenticated;
DO $unverified$
DECLARE r record;
BEGIN
  IF EXISTS(SELECT 1 FROM public.get_own_profile_v1()) THEN RAISE EXCEPTION 'unverified projection granted'; END IF;
  SELECT * INTO r FROM public.save_own_profile_v1('{}','0');
  IF r.status<>'verification_required' THEN RAISE EXCEPTION 'unverified save accepted'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS004','0',true);
  IF r.status<>'verification_required' THEN RAISE EXCEPTION 'unverified claim accepted'; END IF;
END $unverified$;
SET LOCAL request.jwt.claim.sub='00000000-0000-4000-8000-000000000008';
DO $anonymous$
DECLARE r record;
BEGIN
  IF EXISTS(SELECT 1 FROM public.get_own_profile_v1()) THEN RAISE EXCEPTION 'anonymous projection granted'; END IF;
  SELECT * INTO r FROM public.save_own_profile_v1('{}','0');
  IF r.status<>'verification_required' THEN RAISE EXCEPTION 'anonymous save accepted'; END IF;
END $anonymous$;
SET LOCAL request.jwt.claim.sub='00000000-0000-4000-8000-000000000009';
DO $inactive$
DECLARE r record;
BEGIN
  SELECT * INTO r FROM public.get_own_profile_v1();
  IF r.is_active IS DISTINCT FROM false OR r.mec_admitted IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'inactive state lost'; END IF;
  SELECT * INTO r FROM public.save_own_profile_v1('{}','0');
  IF r.status<>'inactive' THEN RAISE EXCEPTION 'inactive save accepted'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS009','0',true);
  IF r.status<>'inactive' THEN RAISE EXCEPTION 'inactive claim accepted'; END IF;
END $inactive$;

SET LOCAL request.jwt.claim.sub='00000000-0000-4000-8000-000000000007';
DO $repair_and_denial$
DECLARE r record; denied boolean;
BEGIN
  SELECT * INTO r FROM public.get_own_profile_v1();
  IF r.id IS DISTINCT FROM '00000000-0000-4000-8000-000000000007'::uuid
    OR r.role<>'student' OR r.profile_contract_version<>0 OR r.profile_revision<>'0'
    OR r.profile_completed IS DISTINCT FROM false OR r.mec_admitted IS DISTINCT FROM false THEN
    RAISE EXCEPTION 'caller missing-profile repair failed'; END IF;
  IF (SELECT count(*) FROM public.get_own_profile_v1())<>1 THEN RAISE EXCEPTION 'repair duplicated projection'; END IF;
  IF EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000005') THEN
    RAISE EXCEPTION 'other-owner row visible'; END IF;
  denied:=false;
  BEGIN UPDATE public.users SET role='super_admin' WHERE id=auth.uid();
  EXCEPTION WHEN insufficient_privilege THEN denied:=true; END;
  IF NOT denied THEN RAISE EXCEPTION 'direct authority write accepted'; END IF;
  denied:=false;
  BEGIN PERFORM email FROM public.users;
  EXCEPTION WHEN insufficient_privilege THEN denied:=true; END;
  IF NOT denied THEN RAISE EXCEPTION 'direct private email read accepted'; END IF;
  denied:=false;
  BEGIN PERFORM * FROM idealab_private.mec_registration_claims_v1;
  EXCEPTION WHEN insufficient_privilege THEN denied:=true; END;
  IF NOT denied THEN RAISE EXCEPTION 'private claims table readable'; END IF;
END $repair_and_denial$;
DO $save_and_claim$
DECLARE r record; p jsonb:=jsonb_build_object('name','Synthetic repaired student','phone','+12025550107',
  'college_roll','MDL00TS007','institution','Model Engineering College','department','Synthetic testing','study_year',2);
BEGIN
  SELECT * INTO r FROM public.save_own_profile_v1(p,'0');
  IF r.status<>'saved' OR r.profile_revision<>'1' THEN RAISE EXCEPTION 'positive profile save failed'; END IF;
  SELECT * INTO r FROM public.get_own_profile_v1();
  IF r.profile_revision<>'1' OR r.profile_completed IS DISTINCT FROM true OR r.profile_contract_version<>1
    OR r.mec_admitted IS DISTINCT FROM false OR r.name<>'Synthetic repaired student' THEN
    RAISE EXCEPTION 'save readback or admission separation failed'; END IF;
  SELECT * INTO r FROM public.save_own_profile_v1(p,'0');
  IF r.status<>'conflict' OR r.profile_revision<>'1' THEN RAISE EXCEPTION 'stale revision accepted'; END IF;
  SELECT * INTO r FROM public.save_own_profile_v1(p||'{"role":"super_admin"}','1');
  IF r.status<>'invalid' OR r.profile_revision<>'1' THEN RAISE EXCEPTION 'metadata authority injection accepted'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS007','1',false);
  IF r.status<>'invalid' THEN RAISE EXCEPTION 'missing declaration accepted'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS007','1',true);
  IF r.status<>'claimed' OR r.profile_revision<>'2' THEN RAISE EXCEPTION 'positive declaration failed'; END IF;
  SELECT * INTO r FROM public.save_own_profile_v1(
    p||'{"name":"Ordinary-save bypass attempt","college_roll":"MDL00TS099"}','2');
  IF r.status<>'claim_transition_required' OR r.profile_revision<>'2' THEN
    RAISE EXCEPTION 'ordinary profile save changed an admitted registration'; END IF;
END $save_and_claim$;
-- Readback occurs in a later request, after the attestation timestamp.
DO $claim_readback_and_retry$
DECLARE r record;
BEGIN
  SELECT * INTO r FROM public.get_own_profile_v1();
  IF r.name IS DISTINCT FROM 'Synthetic repaired student' OR r.college_roll IS DISTINCT FROM 'MDL00TS007'
    OR r.mec_admitted IS DISTINCT FROM true OR r.profile_revision IS DISTINCT FROM '2' THEN
    RAISE EXCEPTION 'rejected ordinary registration change mutated the admitted account'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS007','1',true);
  IF r.status<>'claimed' OR r.profile_revision<>'2' THEN RAISE EXCEPTION 'lost-response retry failed'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS008','2',true);
  IF r.status<>'claimed' OR r.profile_revision<>'3' THEN
    RAISE EXCEPTION 'post-admission registration claim update failed'; END IF;
END $claim_readback_and_retry$;
DO $updated_claim_readback$
DECLARE r record;
BEGIN
  SELECT * INTO r FROM public.get_own_profile_v1();
  IF r.mec_admitted IS DISTINCT FROM true OR r.college_roll<>'MDL00TS008' OR r.profile_revision<>'3' THEN
    RAISE EXCEPTION 'post-admission claim update/readback failed'; END IF;
  SELECT * INTO r FROM public.claim_mec_registration_v1('MDL00TS008','2',true);
  IF r.status<>'claimed' OR r.profile_revision<>'3' THEN
    RAISE EXCEPTION 'post-admission lost-response retry failed'; END IF;
END $updated_claim_readback$;

RESET ROLE;
SET LOCAL ROLE anon;
DO $anon_rpc$
DECLARE denied boolean:=false;
BEGIN
  BEGIN PERFORM * FROM public.get_own_profile_v1();
  EXCEPTION WHEN insufficient_privilege THEN denied:=true; END;
  IF NOT denied THEN RAISE EXCEPTION 'anonymous RPC executable'; END IF;
END $anon_rpc$;

RESET ROLE;
SET LOCAL ROLE postgres;
DO $provision_and_sync$
DECLARE rev bigint; original_role text; original_active boolean; original_ban text; original_banned_at timestamptz;
BEGIN
  INSERT INTO auth.users(id,email,email_confirmed_at,is_anonymous,raw_user_meta_data)
  VALUES('00000000-0000-4000-8000-000000000010','provision@example.invalid',clock_timestamp(),false,
    '{"role":"super_admin","name":"Untrusted metadata","profile_completed":true}');
  IF NOT EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000010'
    AND role='student' AND name='' AND profile_completed=false AND profile_contract_version=0 AND profile_revision=0) THEN
    RAISE EXCEPTION 'verified provisioning defaults/injection denial failed'; END IF;
  IF EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000008') THEN
    RAISE EXCEPTION 'anonymous identity auto-provisioned'; END IF;
  UPDATE auth.users SET email_confirmed_at=clock_timestamp()
    WHERE id='00000000-0000-4000-8000-000000000004';
  IF NOT EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000004'
    AND role='student' AND profile_contract_version=0) THEN RAISE EXCEPTION 'confirmation sync failed'; END IF;
  SELECT profile_revision,role,is_active,ban_reason,banned_at INTO rev,original_role,original_active,original_ban,original_banned_at
    FROM public.users WHERE id='00000000-0000-4000-8000-000000000009';
  UPDATE auth.users SET email='inactive.changed@example.invalid' WHERE id='00000000-0000-4000-8000-000000000009';
  IF NOT EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000009'
    AND email='inactive.changed@example.invalid' AND profile_revision=rev
    AND (role,is_active,ban_reason,banned_at) IS NOT DISTINCT FROM
      (original_role,original_active,original_ban,original_banned_at)) THEN
    RAISE EXCEPTION 'email synchronization changed authority/ban/revision'; END IF;
  BEGIN
    INSERT INTO auth.users(id,email,email_confirmed_at,is_anonymous)
      VALUES('00000000-0000-4000-8000-000000000011','provision@example.invalid',clock_timestamp(),false);
    RAISE EXCEPTION 'email collision should reject Auth trigger operation';
  EXCEPTION WHEN unique_violation THEN NULL; END;
  IF EXISTS(SELECT 1 FROM auth.users WHERE id='00000000-0000-4000-8000-000000000011')
    OR EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000011') THEN
    RAISE EXCEPTION 'email collision left a partial identity/profile'; END IF;
END $provision_and_sync$;

INSERT INTO auth.users(id,email,email_confirmed_at,is_anonymous)
  VALUES('00000000-0000-4000-8000-000000000012','service@example.invalid',NULL,false);
SET LOCAL ROLE service_role;
INSERT INTO public.users(id,name,email,college_roll,role)
  VALUES('00000000-0000-4000-8000-000000000012','Synthetic service fixture','service@example.invalid','MDL00TS012','student');
RESET ROLE;
SET LOCAL ROLE postgres;
DO $service_and_pending$
BEGIN
  IF NOT EXISTS(SELECT 1 FROM public.users WHERE id='00000000-0000-4000-8000-000000000012'
    AND college_roll='MDL00TS012') THEN RAISE EXCEPTION 'trusted service DML failed'; END IF;
  IF EXISTS(SELECT 1 FROM idealab_private.mec_registration_claims_v1 WHERE claim_state='pending') THEN
    RAISE EXCEPTION 'pending claims remain after successful operations'; END IF;
END $service_and_pending$;
SET CONSTRAINTS ALL IMMEDIATE;
SET LOCAL request.jwt.claims='{}';
SET LOCAL request.jwt.claim.sub='';
SELECT true AS synthetic_profile_behavior_checks_passed;

