# MyFlix — User Journey

**User:** one person (the owner). No accounts, no login. **Data:** in-memory React state only; a refresh resets everything to the first-visit state.

## Flow
1. **Load `/`** → no genres chosen yet → redirected to `/welcome`.
2. **Welcome** — "Welcome to MyFlix. What are your 3 favorite genres for movies and shows?" Pick exactly 3 of 7 genres: Action, Comedy, Drama, Sci-Fi, Horror, Romance, Thriller. Continue unlocks at exactly 3.
3. **Home (`/`)** — nav bar, then two carousels with left/right arrows:
   - **I think you'd like** — catalog titles matching the 3 genres.
   - **Continue watching** — titles with a timestamp/episode entered (empty-state message at first).
4. **On any card** — hover highlights; star toggles favorite; Watch/Resume button simulates watching: "Left off" is read-only and updates only when watching (shows advance one episode, S1E1 → S1E2 …, 8 per season; movies advance 20 minutes and clear at 2:00:00); click opens the detail modal.
5. **Detail modal** — large poster, full description, "why I like it", favorite star, progress input.
6. **Currently Watching (`/watching`)** — all cards with progress entered.
7. **Favorites (`/favorites`)** — all starred cards.
8. **Refresh** — everything resets; back to `/welcome`.

## Routes
| Route | Page |
|---|---|
| `/welcome` | Genre onboarding |
| `/` | Home (recommendations + continue watching) |
| `/watching` | Currently Watching |
| `/favorites` | Favorites |
| overlay | Title detail modal |
