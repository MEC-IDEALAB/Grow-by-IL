-- SQL-ONLY DISPOSABLE FIXTURE. Never run against Supabase or an existing database.
-- Emulates the catalog subset used by the candidate; no real provider/token.
DO $fixture_guard$
BEGIN
  IF pg_catalog.current_setting('server_version_num')::integer NOT BETWEEN 170000 AND 179999
    OR pg_catalog.to_regnamespace('auth') IS NOT NULL
    OR pg_catalog.to_regclass('public.users') IS NOT NULL
    OR pg_catalog.to_regnamespace('idealab_private') IS NOT NULL THEN
    RAISE EXCEPTION 'fixture requires fresh disposable PostgreSQL 17';
  END IF;
END $fixture_guard$;
CREATE ROLE postgres NOLOGIN SUPERUSER BYPASSRLS;
CREATE ROLE anon NOLOGIN;
CREATE ROLE authenticated NOLOGIN;
CREATE ROLE service_role NOLOGIN BYPASSRLS;
SET LOCAL ROLE postgres;
SET LOCAL idealab.sql_fixture_only='true';
SET LOCAL idealab.test_legacy_uid='00000000-0000-4000-8000-000000000001';
SET LOCAL idealab.test_other_uid='00000000-0000-4000-8000-000000000002';
SET LOCAL idealab.test_claim_uid='00000000-0000-4000-8000-000000000003';
CREATE SCHEMA auth AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA public,auth TO anon,authenticated,service_role;
CREATE TABLE auth.users (
  id uuid PRIMARY KEY,
  email text,
  email_confirmed_at timestamptz,
  is_anonymous boolean DEFAULT false NOT NULL,
  raw_user_meta_data jsonb DEFAULT '{}'::jsonb NOT NULL
);
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;
CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql STABLE AS $uid$
  SELECT COALESCE(
    NULLIF(current_setting('request.jwt.claim.sub',true),''),
    (NULLIF(current_setting('request.jwt.claims',true),'')::jsonb ->> 'sub')
  )::uuid
$uid$;
CREATE TABLE public.clubs(id uuid PRIMARY KEY);
CREATE TABLE public.users (
  id uuid CONSTRAINT users_pkey PRIMARY KEY,
  name text NOT NULL,
  email text CONSTRAINT users_email_key UNIQUE NOT NULL,
  phone text,
  college_roll text CONSTRAINT users_college_roll_key UNIQUE,
  role text DEFAULT 'student' NOT NULL CONSTRAINT users_role_check
    CHECK(role IN ('student','lab_admin','super_admin')),
  club_id uuid CONSTRAINT fk_users_club REFERENCES public.clubs(id),
  xp integer DEFAULT 0,
  level integer DEFAULT 1,
  reputation_score integer DEFAULT 100,
  qr_code_data text CONSTRAINT users_qr_code_data_key UNIQUE,
  fcm_token text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  profile_completed boolean DEFAULT false,
  avatar_url text,
  is_active boolean DEFAULT true,
  ban_reason text,
  banned_at timestamptz,
  CONSTRAINT users_id_fkey FOREIGN KEY(id) REFERENCES auth.users(id) ON DELETE CASCADE
);
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY users_select_own ON public.users FOR SELECT USING(auth.uid()=id);
CREATE POLICY users_update_own ON public.users FOR UPDATE USING(auth.uid()=id);
CREATE POLICY users_insert_own ON public.users FOR INSERT WITH CHECK(auth.uid()=id);
CREATE POLICY users_read_all ON public.users FOR SELECT TO authenticated USING(true);
GRANT ALL ON public.users TO anon,authenticated,service_role;
CREATE FUNCTION public.get_user_role() RETURNS text LANGUAGE sql STABLE SECURITY DEFINER AS $role$
  SELECT role FROM public.users WHERE id=auth.uid()
$role$;
CREATE FUNCTION public.set_updated_at() RETURNS trigger LANGUAGE plpgsql AS $updated$
BEGIN NEW.updated_at=now(); RETURN NEW; END
$updated$;
INSERT INTO auth.users(id,email,email_confirmed_at,is_anonymous) VALUES
 ('00000000-0000-4000-8000-000000000001','legacy@example.invalid',now(),false),
 ('00000000-0000-4000-8000-000000000002','other@example.invalid',now(),false),
 ('00000000-0000-4000-8000-000000000003','claim@example.invalid',now(),false),
 ('00000000-0000-4000-8000-000000000004','unverified@example.invalid',NULL,false),
 ('00000000-0000-4000-8000-000000000005','admin@example.invalid',now(),false),
 ('00000000-0000-4000-8000-000000000006','super@example.invalid',now(),false),
 ('00000000-0000-4000-8000-000000000007','missing@example.invalid',now(),false),
 ('00000000-0000-4000-8000-000000000008','anonymous@example.invalid',now(),true),
 ('00000000-0000-4000-8000-000000000009','inactive@example.invalid',now(),false);
INSERT INTO public.users(id,name,email,college_roll,role,profile_completed,is_active,ban_reason,banned_at)
 SELECT id,'Synthetic fixture',email,
   CASE WHEN id='00000000-0000-4000-8000-000000000001' THEN ' MDL00TS001 ' ELSE NULL END,
   CASE WHEN id='00000000-0000-4000-8000-000000000005' THEN 'lab_admin'
        WHEN id='00000000-0000-4000-8000-000000000006' THEN 'super_admin' ELSE 'student' END,
   id IN ('00000000-0000-4000-8000-000000000001','00000000-0000-4000-8000-000000000005'),
   id<>'00000000-0000-4000-8000-000000000009',
   CASE WHEN id='00000000-0000-4000-8000-000000000009' THEN 'Synthetic inactive fixture' END,
   CASE WHEN id='00000000-0000-4000-8000-000000000009' THEN now() END
 FROM auth.users WHERE id NOT IN ('00000000-0000-4000-8000-000000000007','00000000-0000-4000-8000-000000000008');
CREATE TEMP TABLE shared_profile_fixture_original AS
 SELECT id,name,email,phone,college_roll,role,is_active,ban_reason,banned_at
 FROM public.users;
SET LOCAL request.jwt.claims='{}';
SET LOCAL request.jwt.claim.sub='';
SELECT true AS synthetic_sql_fixture_ready;

