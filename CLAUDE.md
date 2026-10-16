# MyFlix (full stack)

A personal streaming-style library: browse movies and shows, pick 3 favorite genres, star favorites, and keep a
"Continue watching" list. Two halves in one repo:

| Folder | What it is |
|---|---|
| `front-end/` | The React app (React 19 + Vite, React Router DOM with BrowserRouter, plain CSS, desktop only). Specs live in `front-end/app_outline/` (user journey, style guide, per-page user stories). |
| `supabase/` | The database (Supabase / PostgreSQL 17): `schema.sql`, `seed.sql`, ERD screenshot, `user_stories.md`, `api_notes.md`, and a Postman collection covering all 7 tables. |

## Database (7 tables, all in `public`, all with Row Level Security ON)
`users` (linked to Supabase Auth, row created by a trigger), `genres`, `titles` (movies + shows, `type` = `movie` | `show`),
`title_genres`, `user_genres` (at most 3 picks per user), `favorites`, `in_progress` (`left_off` is free text like `S2E4`).
Read `supabase/api_notes.md` for working example requests, rules and error codes for every table.

## Current state and rules
- **No authentication or authorization yet.** Do not add login, sign-up, sessions, or Row Level Security changes.
  The tables currently have TEMPORARY policies named `dev: open access until auth` (role `anon`, all operations). Leave them.
- Because there is no login, use the single existing row in `users` as the owner of every new `favorites`, `in_progress`
  and `user_genres` row. Look it up; do not create users.
- Do not change tables, columns, or data without the owner's approval. Do not add new tables.
- Talk to the API with the **publishable key only**, read from `import.meta.env` (`VITE_SUPABASE_URL`,
  `VITE_SUPABASE_ANON_KEY` in `front-end/.env`). Never use or commit a secret/service-role key. `.env` must never be committed.
- Keep all Supabase requests in one service file in the front end; components call that, not `fetch` directly.
- Preserve the existing UI and user experience. The database is the source of truth: the old in-memory fake data goes away
  once the real data is wired in.
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
