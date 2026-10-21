-- ============================================================================
-- MyFlix schema — v3 (with authentication)
-- Target: the MyFlix Supabase project, PostgreSQL 17.
--
-- STATUS: APPLIED to the database on 2026-10-19 as 4 migrations:
--   auth_01_users, auth_02_tables, auth_02_seed_catalog (= seed.sql + genres), auth_03_policies.
-- Kept here as the readable source of truth. Catalog seed data is in supabase/seed.sql.
-- Pre-auth data backups (single dev user, no login) are in supabase/backups/ and are NOT re-imported.
--
-- DECISIONS (yours):
--   * Supabase Auth, email + password. public.users.id IS the auth.users id; a trigger creates the row.
--   * Every user_id column: NOT NULL, DEFAULT auth.uid(), ON DELETE CASCADE. The app never sends a user id.
--   * RLS policies are to `authenticated` only. Logged-out visitors (anon) have no table access at all.
--     - users:                     read + update (name only) your own row
--     - genres, titles, title_genres: shared catalog, read-only
--     - user_genres, favorites, in_progress: only your own rows (select/insert/update/delete)
--   * TRUNCATE is revoked from API roles (it ignores RLS).
--   * movies + shows are ONE table, titles(type = 'movie' | 'show').
--   * Genres: the user picks exactly 3 (max 3 enforced here; "exactly 3" is the app's job).
--   * Progress is free text like 'S2E4' (shows) or '1:23:45' (movies).
--   * No database functions are called by the app (no supabase.rpc), so none are defined besides the trigger.
--   * rls_auto_enable() is a project function we did not create; it is not touched here.
--
-- Conventions: snake_case; text (not varchar); timestamptz; uuid ids default gen_random_uuid()
-- (uuidv7() needs PostgreSQL 18; this project is on 17); NOT NULL wherever a value is required;
-- every foreign key has an ON DELETE rule and an index that starts with the FK column.
-- Policies use (select auth.uid()) so Postgres evaluates it once per query, not once per row.
-- ============================================================================


-- ===========================================================================
-- STEP 1 — users (migration auth_01_users)
-- ===========================================================================

-- users — one row per Supabase Auth user. id has NO default: it IS the auth user's id.
create table public.users (
  id         uuid primary key references auth.users (id) on delete cascade,
  name       text,
  email      text,
  created_at timestamptz not null default now(),
  check (name  is null or btrim(name)  <> ''),
  check (email is null or btrim(email) <> '')
);

-- Case-insensitive unique email (A@x.com and a@x.com cannot both exist).
create unique index users_email_lower_key on public.users (lower(email)) where email is not null;

alter table public.users enable row level security;

revoke all on public.users from anon;
revoke insert, delete on public.users from authenticated;

-- Create the public.users row whenever Supabase Auth creates a user. `name` comes from the sign-up
-- metadata (supabase.auth.signUp({ ..., options: { data: { name } } })).
-- SECURITY DEFINER because the new user has no permission to insert here; execute is revoked from every
-- API role so it can't be called through the REST API.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.users (id, name, email)
  values (new.id,
          nullif(btrim(new.raw_user_meta_data ->> 'name'), ''),
          nullif(btrim(new.email), ''));
  return new;
end;
$$;

revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();


-- ===========================================================================
-- STEP 2 — the other tables (migration auth_02_tables)
-- ===========================================================================

-- genres — the pick-list for onboarding (shared catalog)
create table public.genres (
  id   uuid primary key default gen_random_uuid(),
  name text not null unique check (btrim(name) <> '')
);
alter table public.genres enable row level security;

-- titles — movies and shows in one table (shared catalog)
create table public.titles (
  id               uuid primary key default gen_random_uuid(),
  name             text not null check (btrim(name) <> ''),
  type             text not null check (type in ('movie', 'show')),
  description      text,              -- short blurb shown on the card
  full_description text,              -- long text shown in the detail view
  why_i_like_it    text,
  poster_url       text,
  release_year     smallint check (release_year between 1888 and 2200),
  created_at       timestamptz not null default now(),
  unique (type, name)
);
alter table public.titles enable row level security;

-- title_genres — which genres a title belongs to (shared catalog, many-to-many)
create table public.title_genres (
  title_id uuid not null references public.titles (id) on delete cascade,
  genre_id uuid not null references public.genres (id) on delete cascade,
  primary key (title_id, genre_id)
);
create index title_genres_genre_id_idx on public.title_genres (genre_id);
alter table public.title_genres enable row level security;

-- user_genres — the (up to) 3 genres each user picks at first login.
-- pick_order 1..3 + UNIQUE (user_id, pick_order) makes "at most 3 per user" a database rule.
create table public.user_genres (
  user_id    uuid not null default auth.uid() references public.users (id) on delete cascade,
  genre_id   uuid not null references public.genres (id) on delete cascade,
  pick_order smallint not null check (pick_order between 1 and 3),
  primary key (user_id, genre_id),
  unique (user_id, pick_order)
);
create index user_genres_genre_id_idx on public.user_genres (genre_id);
alter table public.user_genres enable row level security;

-- favorites — a user's starred titles. UNIQUE (user_id, title_id) also indexes "all favorites of a user".
create table public.favorites (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references public.users (id)  on delete cascade,
  title_id   uuid not null references public.titles (id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, title_id)
);
create index favorites_title_id_idx on public.favorites (title_id);
alter table public.favorites enable row level security;

-- in_progress — where a user left off. left_off is free text ('S2E4' or '1:23:45', max 24 characters).
-- finished = true keeps the history but drops it from "Continue watching".
create table public.in_progress (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references public.users (id)  on delete cascade,
  title_id   uuid not null references public.titles (id) on delete cascade,
  left_off   text not null check (char_length(btrim(left_off)) between 1 and 24),
  finished   boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, title_id)
);
create index in_progress_title_id_idx on public.in_progress (title_id);
alter table public.in_progress enable row level security;

-- Keep updated_at current automatically.
create extension if not exists moddatetime schema extensions;

create trigger in_progress_set_updated_at
  before update on public.in_progress
  for each row execute function extensions.moddatetime(updated_at);

-- Grants: logged-out visitors get nothing; the catalog is read-only for logged-in users.
revoke all on public.genres, public.titles, public.title_genres,
              public.user_genres, public.favorites, public.in_progress from anon;
revoke insert, update, delete on public.genres, public.titles, public.title_genres from authenticated;

-- Catalog seed (migration auth_02_seed_catalog): the 7 genres below, then supabase/seed.sql.
insert into public.genres (name) values
  ('Action'), ('Comedy'), ('Drama'), ('Sci-Fi'), ('Horror'), ('Romance'), ('Thriller');


-- ===========================================================================
-- STEP 3 — RLS policies (migration auth_03_policies)
-- ===========================================================================

-- users: read + update your own row (name only; email belongs to Supabase Auth)
create policy "users: read own row" on public.users
  for select to authenticated
  using ((select auth.uid()) = id);

create policy "users: update own row" on public.users
  for update to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

revoke update on public.users from authenticated;
grant update (name) on public.users to authenticated;

-- shared catalog: read-only for logged-in users
create policy "genres: read for logged-in users" on public.genres
  for select to authenticated using (true);

create policy "titles: read for logged-in users" on public.titles
  for select to authenticated using (true);

create policy "title_genres: read for logged-in users" on public.title_genres
  for select to authenticated using (true);

-- user_genres: owner only
create policy "user_genres: read own" on public.user_genres
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "user_genres: insert own" on public.user_genres
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "user_genres: update own" on public.user_genres
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "user_genres: delete own" on public.user_genres
  for delete to authenticated using ((select auth.uid()) = user_id);

-- favorites: owner only
create policy "favorites: read own" on public.favorites
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "favorites: insert own" on public.favorites
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "favorites: update own" on public.favorites
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "favorites: delete own" on public.favorites
  for delete to authenticated using ((select auth.uid()) = user_id);

-- in_progress: owner only
create policy "in_progress: read own" on public.in_progress
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "in_progress: insert own" on public.in_progress
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "in_progress: update own" on public.in_progress
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "in_progress: delete own" on public.in_progress
  for delete to authenticated using ((select auth.uid()) = user_id);

-- TRUNCATE ignores RLS: take it away from the API roles.
revoke truncate on public.users, public.genres, public.titles, public.title_genres,
                   public.user_genres, public.favorites, public.in_progress
  from anon, authenticated;

-- delete_my_account(): lets a logged-in user delete their own login. Deleting the auth user cascades to
-- public.users and from there to user_genres, favorites and in_progress. Only the caller's own row is touched.
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- payments — one row per Stripe payment for Premium. Written ONLY by the stripe-webhook edge function
-- (service_role, after it verifies Stripe's signature); the API can only read your own rows.
-- stripe_payment_intent_id is unique so a webhook delivered twice cannot create a duplicate.
create table public.payments (
  id                       uuid primary key default gen_random_uuid(),
  user_id                  uuid not null references public.users (id) on delete cascade,
  stripe_payment_intent_id text not null unique,
  amount                   integer not null check (amount > 0),
  currency                 text not null,
  status                   text not null check (status in ('succeeded', 'failed')),
  created_at               timestamptz not null default now()
);
create index payments_user_id_idx on public.payments (user_id);
alter table public.payments enable row level security;
create policy "payments: read own" on public.payments
  for select to authenticated using ((select auth.uid()) = user_id);
revoke all on public.payments from anon, authenticated;
grant select on public.payments to authenticated;

-- episodes — Season 1 of every show (shared catalog, read-only from the app). Loaded from TMDB (see seed.sql).
-- episode_number follows TMDB, so it can have gaps (The Daily Show's Season 1 jumps from 6 to 56).
create table public.episodes (
  id              uuid primary key default gen_random_uuid(),
  title_id        uuid not null references public.titles (id) on delete cascade,
  season          smallint not null default 1 check (season >= 1),
  episode_number  smallint not null check (episode_number >= 1),
  name            text not null check (btrim(name) <> ''),
  overview        text,
  runtime_minutes smallint check (runtime_minutes > 0),
  air_date        date,
  unique (title_id, season, episode_number)
);
create index episodes_title_id_idx on public.episodes (title_id);
alter table public.episodes enable row level security;
create policy "episodes: read all" on public.episodes
  for select to authenticated using (true);
revoke all on public.episodes from anon, authenticated;
grant select on public.episodes to authenticated;
