# MyFlix

A personal streaming-style library: pick 3 favorite genres, browse movies and shows in carousels, star favorites, and
pick up where you left off. Built as a React front end with a Supabase (PostgreSQL) database.

```
.
├── front-end/    React 19 + Vite + React Router app, with its specs in front-end/app_outline/
├── supabase/     database: schema.sql, seed.sql, ERD, user stories, api_notes.md, Postman collection
├── .claude/      project skills and agents (front-end-agent, supabase-agent)
├── .mcp.json     Supabase MCP connection (project id only, no keys)
├── CLAUDE.md     project guide for Claude Code
└── README.md
```

## Run the app
```bash
cd front-end
npm install
npm run dev        # http://localhost:5173
```
Create `front-end/.env` (never commit it):
```
VITE_SUPABASE_URL=https://<your-project-id>.supabase.co
VITE_SUPABASE_ANON_KEY=<your publishable key>
```

## Database
Seven tables: `users`, `genres`, `titles`, `title_genres`, `user_genres`, `favorites`, `in_progress`.
- `supabase/schema.sql` is the readable source of truth (each table was created as its own migration).
- `supabase/seed.sql` holds the 24 placeholder titles and their genre links.
- `supabase/api_notes.md` lists a working request for every table, the rules, and the error codes you will see.
- `supabase/myflix.postman_collection.json` runs every request against the API (34 requests, 36 checks).

**Status:** authentication and authorization are not built yet. Row Level Security is on for every table, with temporary
`dev: open access until auth` policies so the publishable key can read and write while the app is developed.
Replace them with real per-user policies when login is added.
