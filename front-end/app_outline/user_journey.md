# MyFlix — User Journey

**User:** anyone with a MyFlix account (Supabase Auth, email + password). **Data:** stored in Supabase; each user sees and changes only their own genres, favorites and progress. The catalog is shared.

## Flow
0. **Logged out** → every page redirects to `/login`. New visitors use **Register** (`/register`: name, email, password) and go straight to `/welcome`. Returning users **Log in** and land where they were headed.
1. **Load `/`** → no genres chosen yet → redirected to `/welcome`.
2. **Welcome** — "Welcome to MyFlix. What are your 3 favorite genres for movies and shows?" Pick exactly 3 of 7 genres: Action, Comedy, Drama, Sci-Fi, Horror, Romance, Thriller. Continue unlocks at exactly 3.
3. **Home (`/`)** — nav bar, then two carousels with left/right arrows:
   - **I think you'd like** — catalog titles matching the 3 genres.
   - **Continue watching** — titles with a timestamp/episode entered (empty-state message at first).
4. **On any card** — hover highlights; star toggles favorite; Watch/Resume button simulates watching: "Left off" is read-only and updates only when watching (shows advance one episode, S1E1 → S1E2 …, 8 per season; movies advance 20 minutes and clear at 2:00:00); click opens the detail modal.
5. **Detail modal** — large poster, full description, "why I like it", favorite star, progress input.
6. **Currently Watching (`/watching`)** — all cards with progress entered.
7. **Favorites (`/favorites`)** — all starred cards.
8. **Header** — shows the user's name and a **Log out** button. Log out ends the session, removes the stored tokens and returns to `/login`.
9. **Refresh** — the saved session is recovered and confirmed with Supabase; the user stays logged in with their data.

## Routes
| Route | Page |
|---|---|
| `/login` | Log in (logged-out only) |
| `/register` | Register (logged-out only) |
| `/welcome` | Genre onboarding |
| `/` | Home (recommendations + continue watching) |
| `/watching` | Currently Watching |
| `/favorites` | Favorites |
| overlay | Title detail modal |
