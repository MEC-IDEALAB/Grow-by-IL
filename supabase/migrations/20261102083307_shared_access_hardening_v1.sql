-- Owner-approved shared access hardening, 2 November 2026.
-- Target: existing grow-idealab. Canonical installation uses one atomic DO statement.
-- Reconciles live role helper with existing public.users.role consumers.
-- Contains no user/data/bucket changes; full profile/RLS rollout remains separate.
DO $preflight$
BEGIN
  PERFORM pg_catalog.set_config('lock_timeout','3s',true);
  PERFORM pg_catalog.set_config('statement_timeout','20s',true);
  IF current_setting('server_version_num')::integer < 170000 THEN
    RAISE EXCEPTION 'reviewed baseline requires PostgreSQL 17 or newer';
  END IF;
  IF (SELECT md5(string_agg(c.relname||':'||coalesce(c.relacl::text,''),'|' ORDER BY c.relname))
      FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
      WHERE n.nspname='public' AND c.relkind IN ('r','p'))
      IS DISTINCT FROM 'f8b1d1892fe0f2fd313c4212ba98fb32' THEN
    RAISE EXCEPTION 'table/ACL baseline changed; review again';
  END IF;
  IF EXISTS (
    SELECT 1 FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid
    JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relkind IN ('r','p')
      AND a.attnum>0 AND NOT a.attisdropped AND a.attacl IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'explicit column ACL found; review privilege scope again';
  END IF;
  IF to_regclass('public.users') IS NULL
     OR to_regprocedure('public.get_user_role()') IS NULL
     OR to_regprocedure('public.set_updated_at()') IS NULL THEN
    RAISE EXCEPTION 'shared access baseline does not match';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc p
    WHERE p.oid = 'public.get_user_role()'::regprocedure
      AND p.prorettype = 'text'::regtype AND p.prosecdef
  ) THEN
    RAISE EXCEPTION 'role helper signature does not match';
  END IF;
  IF (SELECT md5(prosrc) FROM pg_proc WHERE oid='public.get_user_role()'::regprocedure)
       IS DISTINCT FROM '3f61846543a82ada7ed61459d2daea32'
     OR (SELECT md5(prosrc) FROM pg_proc WHERE oid='public.set_updated_at()'::regprocedure)
       IS DISTINCT FROM '75ee85bfb81cf640baf932f177bf1044' THEN
    RAISE EXCEPTION 'reviewed function body has changed';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_proc
    WHERE oid IN ('public.get_user_role()'::regprocedure,'public.set_updated_at()'::regprocedure)
    AND (proconfig IS NOT NULL OR proacl::text IS DISTINCT FROM
      '{=X/postgres,postgres=X/postgres,anon=X/postgres,authenticated=X/postgres,service_role=X/postgres}')) THEN
    RAISE EXCEPTION 'function permission/config baseline changed; review again';
  END IF;


-- These administrative privileges are unused by ordinary PostgREST DML.
-- RLS does not protect TRUNCATE, so remove its table privilege explicitly.
REVOKE TRUNCATE, TRIGGER, REFERENCES, MAINTAIN
  ON TABLE public."clubs",
  public."events",
  public."knowledge_articles",
  public."lab_sessions",
  public."notifications",
  public."project_members",
  public."projects",
  public."rsvps",
  public."tool_bookings",
  public."tools",
  public."user_education",
  public."user_experience",
  public."user_interests",
  public."user_portfolio_projects",
  public."user_profiles",
  public."user_skills",
  public."user_social_links",
  public."user_volunteering",
  public."users"
  FROM anon, authenticated;

-- Both existing bodies qualify application/Auth references; builtins use pg_catalog.
ALTER FUNCTION public.get_user_role() SET search_path = pg_catalog;
ALTER FUNCTION public.set_updated_at() SET search_path = pg_catalog;
REVOKE EXECUTE ON FUNCTION public.get_user_role() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_user_role() TO authenticated, service_role;



END
$preflight$;
