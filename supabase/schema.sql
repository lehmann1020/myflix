-- ============================================================================
-- MyFlix schema — revised version (v2)
-- Based on supabase/task-manager-erd.png, with the review changes you approved.
-- Target: the MyFlix Supabase project, PostgreSQL 17.
--
-- STATUS: APPLIED to the database (7 migrations, one per table, 2026-10-15). Kept here as the readable source of truth.
-- Seed data (24 titles + genre links) is in supabase/seed.sql.
--
-- DECISIONS (yours):
--   * Anonymous sign-in now; public.users.id links to Supabase Auth (auth.users)
--   * movies + shows merged into ONE table, titles(type = 'movie' | 'show')   ("whatever is best")
--   * Genres: the user picks exactly 3 at first login (max 3 enforced here; "exactly 3" is the app's job)
--   * Progress is free text like 'S2E4' (shows) or '1:23:45' (movies)
--   * movies.favorite / shows.favorite booleans removed; the favorites table is kept
--   * Row Level Security POLICIES are NOT written here — you will add them.
--     (This project's ensure_rls event trigger turns RLS ON for every new public table, so until you add
--      policies the tables are invisible to the API. The explicit "enable row level security" lines below
--      only document that.)
--
-- Creation order (each step is one pause for you to verify in the dashboard):
--   1. users (+ trigger that creates a users row for every new auth user)
--   2. genres (+ the 7 genre names)
--   3. titles
--   4. title_genres
--   5. user_genres
--   6. favorites
--   7. in_progress (+ auto-updating updated_at)
--
-- Conventions: snake_case; text (not varchar); timestamptz; uuid ids default gen_random_uuid()
-- (uuidv7() needs PostgreSQL 18; this project is on 17); NOT NULL wherever a value is required;
-- every foreign key has an ON DELETE rule and an index that starts with the FK column.
-- ============================================================================


-- ---------------------------------------------------------------------------
-- 1. users — one row per Supabase Auth user (anonymous or permanent)
-- ---------------------------------------------------------------------------
-- id has NO default: it IS the auth user's id. name/email stay NULL for anonymous users and are
-- filled in later when the user signs up with an email (story 1).
create table public.users (
  id         uuid primary key references auth.users (id) on delete cascade,
  name       text,
  email      text,
  created_at timestamptz not null default now(),
  check (name  is null or btrim(name)  <> ''),
  check (email is null or btrim(email) <> '')
);

-- Case-insensitive unique email (A@x.com and a@x.com cannot both exist). NULLs (anonymous users) are allowed.
create unique index users_email_lower_key on public.users (lower(email)) where email is not null;

alter table public.users enable row level security;

-- 1b. Create the public.users row automatically whenever Supabase Auth creates a user
--     (including anonymous sign-ins). SECURITY DEFINER because the signing-in user has no permission
--     to insert here; execute is revoked from every API role so it can't be called through the REST API.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.users (id, name, email)
  values (new.id, nullif(btrim(new.raw_user_meta_data ->> 'name'), ''), nullif(btrim(new.email), ''));
  return new;
end;
$$;

revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();


-- ---------------------------------------------------------------------------
-- 2. genres — the pick-list for onboarding
-- ---------------------------------------------------------------------------
create table public.genres (
  id   uuid primary key default gen_random_uuid(),
  name text not null unique check (btrim(name) <> '')
);

alter table public.genres enable row level security;

insert into public.genres (name) values
  ('Action'), ('Comedy'), ('Drama'), ('Sci-Fi'), ('Horror'), ('Romance'), ('Thriller');


-- ---------------------------------------------------------------------------
-- 3. titles — movies and shows in one table (replaces the diagram's movies + shows)
-- ---------------------------------------------------------------------------
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


-- ---------------------------------------------------------------------------
-- 4. title_genres — which genres a title belongs to (many-to-many)
-- ---------------------------------------------------------------------------
create table public.title_genres (
  title_id uuid not null references public.titles (id) on delete cascade,
  genre_id uuid not null references public.genres (id) on delete cascade,
  primary key (title_id, genre_id)
);

create index title_genres_genre_id_idx on public.title_genres (genre_id);

alter table public.title_genres enable row level security;


-- ---------------------------------------------------------------------------
-- 5. user_genres — the (up to) 3 genres each user picks at first login (story 2)
-- ---------------------------------------------------------------------------
-- pick_order 1..3 + UNIQUE (user_id, pick_order) makes "at most 3 per user" a database rule with no
-- trigger. "Exactly 3" is enforced by the app's onboarding screen (it cannot be a simple constraint).
create table public.user_genres (
  user_id    uuid not null references public.users (id) on delete cascade,
  genre_id   uuid not null references public.genres (id) on delete cascade,
  pick_order smallint not null check (pick_order between 1 and 3),
  primary key (user_id, genre_id),
  unique (user_id, pick_order)
);

create index user_genres_genre_id_idx on public.user_genres (genre_id);

alter table public.user_genres enable row level security;


-- ---------------------------------------------------------------------------
-- 6. favorites — a user's starred titles (story 3)
-- ---------------------------------------------------------------------------
-- UNIQUE (user_id, title_id) stops the same favorite being added twice, and also serves as the
-- index for "all favorites of a user". The extra index covers "who favorited this title" and deletes.
create table public.favorites (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.users (id)  on delete cascade,
  title_id   uuid not null references public.titles (id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, title_id)
);

create index favorites_title_id_idx on public.favorites (title_id);

alter table public.favorites enable row level security;


-- ---------------------------------------------------------------------------
-- 7. in_progress — titles a user started but hasn't finished, and where they left off (story 4)
-- ---------------------------------------------------------------------------
-- left_off is free text, as in the app: 'S2E4' for a show, '1:23:45' for a movie (max 24 characters).
-- One row per (user, title). finished = true keeps the history but drops it from "Continue watching".
create table public.in_progress (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.users (id)  on delete cascade,
  title_id   uuid not null references public.titles (id) on delete cascade,
  left_off   text not null check (char_length(btrim(left_off)) between 1 and 24),
  finished   boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, title_id)
);

create index in_progress_title_id_idx on public.in_progress (title_id);

alter table public.in_progress enable row level security;

-- Keep updated_at current automatically (the moddatetime extension is available but not installed yet).
create extension if not exists moddatetime schema extensions;

create trigger in_progress_set_updated_at
  before update on public.in_progress
  for each row execute function extensions.moddatetime(updated_at);
