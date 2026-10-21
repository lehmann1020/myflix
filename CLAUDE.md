# MyFlix (full stack)

A personal streaming-style library: register or log in, pick 3 favorite genres, browse movies and shows, star favorites,
and keep a "Continue watching" list. Each user sees only their own picks, favorites and progress. Two halves in one repo:

| Folder | What it is |
|---|---|
| `front-end/` | The React app (React 19 + Vite, React Router DOM with BrowserRouter, plain CSS, desktop only). Specs live in `front-end/app_outline/` (user journey, style guide, per-page user stories). |
| `supabase/` | The database (Supabase / PostgreSQL 17): `schema.sql`, `seed.sql`, ERD screenshot, `user_stories.md`, `api_notes.md`, and a Postman collection that logs in two test users and covers the original 7 tables. |

## Database (9 tables, all in `public`, all with Row Level Security ON)
`users` (id = Supabase Auth user id, row created by a trigger), `genres`, `titles` (movies + shows, `type` = `movie` | `show`),
`title_genres`, `user_genres` (at most 3 picks per user), `favorites`, `in_progress` (`left_off` is free text like `S2E4`),
`episodes` (Season 1 of every show, from TMDB; read-only), `payments` (one row per Stripe Premium payment; read-only from
the app, written only by the `stripe-webhook` edge function).
Read `supabase/api_notes.md` for working example requests, rules and error codes for every table.

## Current state and rules
- **Authentication is done** (Supabase Auth, email + password, "Confirm email" off for development). The app has
  `/login` and `/register` (logged-out only); every other page requires a logged-in user (`RequireAuth`). The header shows
  the user's name and a Log out button; Welcome has a Log out link. A refresh recovers and confirms the saved session.
- `users.id` is the `auth.users` id, and the `on_auth_user_created` trigger creates the `users` row on sign-up (name from
  the sign-up metadata). Every `user_id` column is `not null default auth.uid() on delete cascade`; the app never sends a user id.
- RLS policies are to `authenticated` only; `anon` has no table access. Per-user tables (`favorites`, `in_progress`,
  `user_genres`) allow only the owner's rows (`auth.uid() = user_id`). Catalog tables (`genres`, `titles`, `title_genres`)
  are read-only. `users`: read and update (name only) your own row. TRUNCATE is revoked. Do not add `dev:`/anon policies back.
- Do not change tables, columns, policies, or data without the owner's approval. Do not add new tables beyond the 9 above (`payments` and `episodes` were approved by the owner).
  `supabase/schema.sql` matches the database; pre-auth CSV backups are in `supabase/backups/` (not re-imported).
- Talk to the API with the **publishable key only**, read from `import.meta.env` (`VITE_SUPABASE_URL`,
  `VITE_SUPABASE_ANON_KEY` in `front-end/.env`). Never use or commit a secret/service-role key in the app or repo. `.env` must never be committed.
  **One owner-approved exception:** the `stripe-webhook` edge function writes `payments` with the service-role key that Supabase injects
  into the function at runtime (it is never in the repo, `.env` or the browser). Nothing else may use it.
- Stripe (one-time Premium payment, test mode): `VITE_STRIPE_PUBLISHABLE_KEY` in `front-end/.env`; `STRIPE_SECRET_KEY` and
  `STRIPE_WEBHOOK_SECRET` only in Supabase Edge Function secrets. The server sets the price; the webhook is the source of truth for payments.
- Keep all Supabase requests in one service file, `front-end/src/services/myflixApi.js`; components call that, not `fetch`
  or supabase-js directly. It uses `@supabase/supabase-js` for auth and plain `fetch` with the user's access token for tables.
- Auth state lives in `front-end/src/state/AuthProvider.jsx` (`useAuth()`); library data in `MyFlixContext.jsx` (`useMyFlix()`),
  remounted per user so one user's data never shows for another.
- Preserve the existing UI and user experience. The database is the source of truth.
- Desktop only. Verify UI work with the Playwright MCP and database work with the Supabase MCP.

## Agents and tools
- `.claude/agents/front-end-agent.md` (React, Vite, Router, UI/UX) and `.claude/agents/supabase-agent.md` (database, API, security).
  The main session orchestrates both. Skills: `frontend-design`, `ui-ux-pro-max`, `taste-skill`, `design-motion-principles`,
  `postgresql-table-design`.
- MCP servers: `supabase` (project-scoped in `.mcp.json`), Context7, Playwright, Chrome DevTools.

## Commands
```bash
cd front-end
npm install
npm run dev      # http://localhost:5173
npm run build
npm run lint
```
