# MyFlix API notes

How to call the MyFlix Supabase API now that it has real logins. Every request below was sent to the live
Supabase API (Auth + REST) and returned the status shown. IDs are placeholders (`<id>`).

> **Draft written by Claude from tested requests.** Read it and make sure you can explain each table before
> you hand it in or rely on it.

## Postman collection
`supabase/myflix.postman_collection.json` has every request below: **51 requests and 101 checks in 11 folders**.
Import it in Postman, set the collection variable `publishable_key`, and run it with the Collection Runner, in order.

- Folder **0 Auth** signs up two test accounts (`myflix-test-a@example.com`, `myflix-test-b@example.com`) or reuses them
  if they already exist, signs both in, and saves `access_token` / `user_id` (user A) and `access_token_b` / `user_id_b`
  (user B). Every table request after that sends a user's token.
- Folder **8 Isolation** uses user B's token against user A's rows.
- Folder **10 Cleanup** deletes the rows the run created and signs both users out. The two test accounts stay in
  **Authentication → Users**, because the publishable key can't delete accounts. Delete them there if you want a clean list.
- It was run end to end with newman against the live database twice (first run creates the accounts, second run reuses
  them): **51/51 requests and 101/101 checks passed** both times.
- Needs **Confirm email OFF** (Authentication → Sign In / Providers → Email). With it on, sign-up returns no token.

## Setup
- **Base URL:** `{{base_url}}` = `https://<project-id>.supabase.co`.
  Auth lives at `{{base_url}}/auth/v1/…`, tables at `{{base_url}}/rest/v1/<table>`.
- **Key:** the publishable key (`sb_publishable_…`) in the Postman variable `publishable_key`. Never the secret key.
- **Headers on every table request:**
  ```
  apikey:{{publishable_key}}
  Authorization:Bearer {{access_token}}
  Content-Type:application/json
  ```
  `apikey` says which project; the **access token** says *who you are*. The token's `role` claim is `authenticated` and its
  `sub` claim is your user id: that's what `auth.uid()` returns inside the database.
- **Logged out** (only `apikey`, no `Authorization`): you're the `anon` role, which has **no access to any table** → 401.
- **`Authorization` must hold a real access token.** An empty or broken value (e.g. `{{access_token}}` saved as `null`)
  gives 401 `PGRST301 Expected 3 parts in JWT; got 1` (seen in Part 1). Logged-out requests should leave the header off.
- **`Prefer: return=representation`** (writes only): the response body contains the saved row(s). Without it a POST is
  **201** with an empty body and a DELETE is **204**.
- **Filters** use PostgREST syntax: `?column=eq.value`, several with `&`, `in.(a,b)` for a list.
- **Always filter a PATCH and a DELETE.** They apply to every row that matches the filter (and that RLS lets you see).
- **Tokens expire after 1 hour** (`expires_in: 3600`). A request with an expired token → 401 `JWT expired`. Sign in again.

## Auth requests
| Action | Request | Result |
|---|---|---|
| Sign up | `POST /auth/v1/signup` `{"email":"…","password":"…","data":{"name":"Ava"}}` | 200 with `access_token`, `refresh_token`, `expires_in: 3600`, `user` |
| Sign up, email already used | same | 422 `User already registered` |
| Log in | `POST /auth/v1/token?grant_type=password` `{"email":"…","password":"…"}` | 200, same shape as sign up |
| Log in, wrong password | same | 400 `invalid_credentials` (`Invalid login credentials`) |
| Who am I? | `GET /auth/v1/user` (with the token) | 200, the user (`id`, `email`, `role: authenticated`) |
| Log out | `POST /auth/v1/logout` (with the token) | 204 |

Auth requests send only `apikey` (plus `Authorization` for "who am I" and log out).
`data.name` on sign-up goes into the user's metadata; the database trigger copies it into `public.users.name`.

## Who can do what (Row Level Security)
RLS is on for every table, and every policy is **to `authenticated`**. There are no `anon` policies and no grants for `anon`.

| Table | Logged-in user can | How |
|---|---|---|
| `genres`, `titles`, `title_genres` | read everything | shared catalog: SELECT policy `using (true)`; no insert/update/delete grants |
| `users` | read and update **their own row**, `name` only | `auth.uid() = id`; only `UPDATE (name)` is granted; rows come from the sign-up trigger |
| `user_genres`, `favorites`, `in_progress` | read, add, change, delete **their own rows** | `auth.uid() = user_id` on every operation (`with check` on insert/update) |

**You never send `user_id`.** Every `user_id` column is `default auth.uid()`, so the database fills it in from your token.
If you do send someone else's `user_id`, the insert is rejected (403).

## Status codes seen
| Code | Meaning here |
|---|---|
| 200 | GET / PATCH worked (and DELETE or upsert with `return=representation`). Also: a GET, PATCH or DELETE that matched **none of your rows** is 200 with `[]` |
| 201 | POST created a row |
| 204 | DELETE without `return=representation`; log out |
| 400 + `23514` | a CHECK rule failed (`pick_order` 4, blank `left_off`) |
| 400 `invalid_credentials` | wrong email or password |
| 401 + `42501` | logged out (no token): `permission denied for table …` |
| 401 `PGRST301` | the `Authorization` value isn't a JWT (e.g. an empty or `null` `{{access_token}}`) |
| 403 + `42501` `permission denied for table …` | logged in, but the role has no grant: writing to the catalog, POST to `users`, PATCH `users.email` |
| 403 + `42501` `new row violates row-level security policy` | logged in, but the row isn't yours (e.g. POST a favorite with another user's `user_id`) |
| 409 + `23505` | duplicate (a UNIQUE rule) |
| 409 + `23503` | foreign key: the referenced title/genre doesn't exist |
| 422 | sign up with an email that already has an account |

**401 vs 403 vs `[]`:** 401 = who are you? (no valid token). 403 = I know who you are, and you can't do that.
`[]` = RLS silently hid other people's rows: reading, changing or deleting *someone else's* row doesn't error, it just matches nothing.

---

## genres  (7 rows: Action, Comedy, Drama, Horror, Romance, Sci-Fi, Thriller) — read-only
| Operation | Request | Result |
|---|---|---|
| GET all | `GET /genres?select=id,name&order=name` | 200, 7 rows |
| GET filter | `GET /genres?select=id,name&name=eq.Action` | 200, one row |
| POST / PATCH / DELETE | any write | 403 `42501` `permission denied for table genres` |

## titles  (40 seeded from TMDB, movies and shows in one table) — read-only
- **GET all** `GET /titles?select=id,name,type&order=name` → 200, 24 rows.
- **GET filter** `GET /titles?select=id,name,type&type=eq.show&name=eq.Echo%20Drift` → 200, one row.
- **POST / PATCH / DELETE** → 403 `42501` `permission denied for table titles`.
- Columns: `name`, `type` (`movie` | `show`), `description`, `full_description`, `why_i_like_it`, `poster_url`, `release_year`.

## title_genres  (77 seeded links) — read-only
- **GET filter** `GET /title_genres?select=*&title_id=eq.<title id>` → 200 (Echo Drift has 2: Sci-Fi, Drama).
- **GET with genre names** `GET /titles?select=name,title_genres(genres(name))&id=eq.<title id>` → 200.
- **POST** → 403 `42501`.

## users  (one row per account; you only see yours)
- **GET** `GET /users?select=id,name,email` → 200 with **exactly one row: yours**.
- **GET someone else's** `GET /users?select=id,name&id=eq.<other user id>` → 200 `[]`.
- **PATCH** `PATCH /users?id=eq.<your id>` `{"name":"Ava"}` → 200.
- **PATCH email** `{"email":"…"}` → 403 `42501`. The email belongs to Supabase Auth; only `name` is editable here.
- **POST** → 403 `42501`. The row is created by the `on_auth_user_created` trigger when you sign up.
  Deleting the account in Authentication → Users deletes this row and all of that user's picks, favorites and progress (cascade).

## user_genres  (your up-to-3 genre picks)
- **POST** `{"genre_id":"<genre id>","pick_order":1}` → 201; the returned row's `user_id` is yours.
- **GET** `GET /user_genres?select=pick_order,genres(name)&order=pick_order` → 200, only your picks.
- **PATCH** `PATCH /user_genres?genre_id=eq.<genre id>` `{"pick_order":2}` → 200.
- **DELETE** `DELETE /user_genres?genre_id=eq.<genre id>` → 200 (with `return=representation`).
  To replace all picks the app runs `DELETE /user_genres?pick_order=gte.1` (a filter is required) and then POSTs the new 3.
- Rules: `pick_order` 1, 2 or 3 (so at most 3), unique per user; a genre once per user.
  Error: `pick_order` 4 → 400 `23514`. "Exactly 3" is up to the app.

## favorites
- **POST** `{"title_id":"<title id>"}` → 201; `user_id` is filled from your token.
- **GET** `GET /favorites?select=created_at,titles(name,type)` → 200, only yours.
- **DELETE** `DELETE /favorites?title_id=eq.<title id>` → 200 / 204. (Nothing to PATCH.)
- Errors: same title twice → 409 `23505`; a `title_id` that doesn't exist → 409 `23503`.

## in_progress  (where you left off)
- **POST** `{"title_id":"<title id>","left_off":"S2E4"}` → 201; `finished` defaults to false.
- **GET Continue watching** `GET /in_progress?select=left_off,finished,titles(name,type)&finished=eq.false` → 200.
- **PATCH** `PATCH /in_progress?title_id=eq.<title id>` `{"left_off":"S2E5"}` → 200 (`updated_at` refreshes automatically),
  or `{"finished":true}` → 200.
- **Upsert (what the app sends when you press Watch):**
  `POST /in_progress?on_conflict=user_id,title_id` with `Prefer: resolution=merge-duplicates` and
  `{"title_id":"<title id>","left_off":"S2E6","finished":false}` → 200/201. Creates the row or updates it.
- **DELETE** `DELETE /in_progress?title_id=eq.<title id>` → 200 / 204.
- Rules: `left_off` free text, 1–24 characters (`S2E4`, `1:23:45`); one row per user + title.
  Error: blank `left_off` → 400 `23514`.

---

## Isolation, tested with two accounts (folder 8)
User A has a favorite and an `in_progress` row. With **user B's** token:

| Request | Result |
|---|---|
| `GET /favorites?select=*` | 200 `[]` — B doesn't see A's favorite |
| `GET /in_progress?select=*` | 200 `[]` |
| `PATCH /in_progress?title_id=eq.<A's title>` `{"left_off":"HACKED"}` | 200 `[]` — nothing changed (A still at S2E6) |
| `DELETE /favorites?title_id=eq.<A's title>` | 200 `[]` — nothing deleted |
| `POST /favorites` `{"user_id":"<A's id>","title_id":"…"}` | 403 `42501` `new row violates row-level security policy for table "favorites"` |

With **no token** (only `apikey`): `GET /titles` and `GET /favorites` → 401 `42501` `permission denied`.

## Queries the app uses (all tested, logged in)
| Need | Request |
|---|---|
| My profile (header name) | `GET /users?select=name,email` |
| Titles in my genres | `GET /titles?select=name,type,title_genres!inner(genres!inner(name))&title_genres.genres.name=in.(Action,Sci-Fi)` → 200, 10 titles |
| All titles with genres (what the app loads) | `GET /titles?select=id,name,type,description,full_description,poster_url,title_genres(genres(name))&order=name` |
| My favorites, with title info | `GET /favorites?select=created_at,titles(name,type)` |
| Continue watching, with title info | `GET /in_progress?select=left_off,finished,titles(name,type)&finished=eq.false` |

## Delete account (RPC)
| Need | Request |
|---|---|
| Delete my own account and everything saved under it | `POST /rpc/delete_my_account` with body `{}` and the user's token → 204. Anonymous callers are refused. |

The function is `security definer` and only deletes `auth.uid()`'s own login. Their `users` row, genre picks, favorites and progress go with it (cascade).
Tested in the app: after the call, the auth user and `users` row were gone and other accounts were untouched.

## Tricky things
- No `user_id` filter is needed on the per-user tables: RLS already limits every query to the token's user.
- A request that touches someone else's row returns **200 `[]`**, not an error. Check the row count if you need to know.
- An empty `{{access_token}}` (e.g. sign-in failed, or a script overwrote it) gives 401 `PGRST301 Expected 3 parts in JWT`.
  Only the Sign up / Sign in requests should save the token.
- The front end doesn't build these by hand for auth: it uses `@supabase/supabase-js` (in `front-end/src/services/myflixApi.js`)
  for sign up / log in / log out / session refresh, and plain `fetch` with the user's token for the table requests above.
- Not tested: PUT, paging (`limit`/`offset`), refresh-token requests (`grant_type=refresh_token`), and password reset.
