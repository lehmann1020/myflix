# MyFlix API notes

Context for Claude (Part II). Every request below was actually sent to the live Supabase REST API with the
publishable key and returned the status shown. IDs are placeholders (`<id>`).

> **Draft written by Claude from tested requests.** Read it and make sure you can explain each table before
> you hand it in or rely on it.

## Postman collection
`supabase/myflix.postman_collection.json` has every request below (34 requests, 36 checks, in 9 folders). Import it in Postman,
set the collection variable `publishable_key`, and run it with the Collection Runner. It saves the ids it needs between
requests and removes its own test rows at the end. It was run end to end with newman against the live database: 34/34 requests
and 36/36 checks passed.

## Setup
- **Base URL:** `{{base_url}}` = `https://<project-id>.supabase.co`. Tables live at `{{base_url}}/rest/v1/<table>`.
- **Key:** the publishable key (`sb_publishable_…`) in the Postman variable `publishable_key`. Never the secret key.
- **Headers on every request:**
  ```
  apikey:{{publishable_key}}
  Authorization:Bearer {{publishable_key}}
  Content-Type:application/json
  ```
  `apikey` is the one that matters: with only `Authorization` the API answers **401** `No API key found in request`.
- **`Prefer: return=representation`** (extra header, writes only): the response body contains the saved row, so a POST
  shows the new `id`. Without it a POST is **201** with an empty body. A DELETE returns **200** with the deleted row
  when it is set, or **204** with no body without it (or with `Prefer: return=minimal`).
- **Filters** use PostgREST syntax: `?column=eq.value`, several with `&`, `in.(a,b)` for a list.
- **Always filter a PATCH and a DELETE** (`?id=eq.<id>`). They apply to every row that matches the filter.
- **Row Level Security** is on for every table. Right now each table has one TEMPORARY policy,
  `dev: open access until auth` (role `anon`, all operations, `true`), so the publishable key can read and write
  everything. These come out when real auth policies are written.

## Status codes seen
| Code | Meaning here |
|---|---|
| 200 | GET / PATCH worked (and DELETE with `return=representation`) |
| 201 | POST created a row |
| 204 | DELETE worked (no body) |
| 400 + `23514` | a CHECK rule failed (bad `type`, blank name, `pick_order` 4, blank `left_off`) |
| 409 + `23505` | duplicate (a UNIQUE rule) |
| 409 + `23503` | foreign key: the referenced user/title/genre doesn't exist |
| 401 | no `apikey` header |

## One placeholder user
The user tables need a real user. One placeholder user exists (anonymous-style, no email, name set to
"MyFlix Dev User"). Its `public.users` row was created automatically by the trigger when the auth user was created.
Use its id wherever a request needs `<user id>`. Keep it until real logins exist.

---

## genres  (7 pick-list rows: Action, Comedy, Drama, Horror, Romance, Sci-Fi, Thriller)
| Operation | Request | Result |
|---|---|---|
| GET all | `GET /genres?select=name` | 200 |
| GET filter | `GET /genres?select=id,name&name=eq.Action` | 200, one row |
| POST | `POST /genres` `{"name":"Documentary"}` | 201 |
| PATCH | `PATCH /genres?id=eq.<id>` `{"name":"Documentaries"}` | 200 |
| DELETE | `DELETE /genres?id=eq.<id>` | 200 / 204 |

Rules: `name` required, non-blank, unique. Errors: duplicate name (e.g. `Action`) → 409 `23505`; blank name `"   "` → 400 `23514`.

## titles  (movies and shows in one table; 24 seeded)
- **POST** `{"name":"My Show","type":"show","description":"…","poster_url":"/posters/x.jpg"}` → 201.
- **GET all** `GET /titles?select=id` → 200. **GET filter** `GET /titles?select=name,type&type=eq.movie` → 200.
- **PATCH** `PATCH /titles?id=eq.<id>` `{"description":"edited"}` → 200. **DELETE** `DELETE /titles?id=eq.<id>` → 200/204.
- Rules: `name` required and non-blank; `type` must be exactly `movie` or `show`; `(type, name)` must be unique.
  Optional: `description`, `full_description`, `why_i_like_it`, `poster_url`, `release_year` (1888–2200).
- Errors: duplicate (same type + name) → 409 `23505`; `type:"podcast"` → 400 `23514`.
- Deleting a title also deletes its `title_genres`, `favorites` and `in_progress` rows (ON DELETE CASCADE).

## title_genres  (links a title to a genre; 39 seeded)
- **POST** `{"title_id":"<title id>","genre_id":"<genre id>"}` → 201.
- **GET filter** `GET /title_genres?select=*&title_id=eq.<title id>` → 200.
- **GET with genre names** `GET /titles?select=name,title_genres(genres(name))&id=eq.<title id>` → 200.
- **DELETE** `DELETE /title_genres?title_id=eq.<title id>&genre_id=eq.<genre id>` → 200/204. (Nothing useful to PATCH.)
- Rules: the pair `(title_id, genre_id)` is the primary key; both must exist. Error: same link twice → 409 `23505`.

## users  (one row per auth user)
- **GET** `GET /users?select=id,name,email` → 200. **GET filter** `GET /users?select=id,name&id=eq.<user id>` → 200.
- **PATCH** `PATCH /users?id=eq.<user id>` `{"name":"MyFlix Dev User"}` → 200.
- **No POST:** rows are created by a trigger when Supabase Auth creates a user. A POST with that id → 409 `23505`;
  a POST with an id that isn't an auth user → 409 `23503`.
- `name` and `email` are optional (anonymous users have neither). Email is unique ignoring case. Don't DELETE the kept user.

## user_genres  (a user's up-to-3 genre picks)
- **POST** `{"user_id":"<user id>","genre_id":"<genre id>","pick_order":1}` → 201.
- **GET filter** `GET /user_genres?select=*&user_id=eq.<user id>` → 200.
- **PATCH** `PATCH /user_genres?user_id=eq.<user id>&genre_id=eq.<genre id>` `{"pick_order":2}` → 200.
- **DELETE** same filter → 200/204.
- Rules: `pick_order` must be 1, 2 or 3 (so at most 3 picks per user), and is unique per user; a genre can be picked once per user.
  Errors: `pick_order` 4 → 400 `23514`; reusing a `pick_order` → 409 `23505`. "Exactly 3" is up to the app.

## favorites
- **POST** `{"user_id":"<user id>","title_id":"<title id>"}` → 201.
- **GET filter** `GET /favorites?select=title_id,created_at&user_id=eq.<user id>` → 200.
- **DELETE** `DELETE /favorites?user_id=eq.<user id>&title_id=eq.<title id>` → 200/204. (Nothing to PATCH.)
- Rules: both ids must exist; one favorite per user + title. Error: favoriting the same title twice → 409 `23505`.

## in_progress  (where a user left off)
- **POST** `{"user_id":"<user id>","title_id":"<title id>","left_off":"S2E4"}` → 201. `finished` defaults to false.
- **GET unfinished (Continue watching)** `GET /in_progress?select=left_off,finished&user_id=eq.<user id>&finished=eq.false` → 200.
- **PATCH** `PATCH /in_progress?user_id=eq.<user id>&title_id=eq.<title id>` `{"left_off":"S2E5"}` → 200
  (`updated_at` refreshes automatically), or `{"finished":true}` → 200.
- **DELETE** same filter → 200/204.
- Rules: `left_off` is free text, 1–24 characters (`S2E4` for a show, `1:23:45` for a movie); one row per user + title.
  Errors: blank `left_off` → 400 `23514`; a second row for the same user + title → 409 `23505`.

---

## Queries the app will need (all tested)
| Need | Request |
|---|---|
| Titles in the user's genres | `GET /titles?select=name,type,title_genres!inner(genres!inner(name))&title_genres.genres.name=in.(Action,Sci-Fi)` → 200 (10 titles for Action + Sci-Fi) |
| A user's favorites, with title info | `GET /favorites?select=created_at,titles(name,type)&user_id=eq.<user id>` → 200 |
| Continue watching, with title info | `GET /in_progress?select=left_off,finished,titles(name,type)&user_id=eq.<user id>&finished=eq.false` → 200 |
| Titles with their genres | `GET /titles?select=name,title_genres(genres(name))` → 200 (tested with `&id=eq.<title id>`; the unfiltered form was not run) |

## Tricky things
- Foreign keys: a title, genre or user must exist before anything points at it. The user tables fail with 409 `23503` otherwise.
- The user's `users` row only appears because an auth user exists; there's no way to create one through the REST API.
- The genre-filter query uses `!inner` on both embedded tables; that version is the one that was tested. I did not test what the
  same query returns without `!inner`.
- Not tested: PUT, sorting (`order=`), paging (`limit`/`offset`) beyond `limit`, and writes by a signed-in (non-anon) user.
