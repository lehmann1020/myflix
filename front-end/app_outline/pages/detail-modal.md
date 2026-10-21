# Overlay: Title Detail Modal
```
+------------------------------------+
| [X]                                |
| [ poster ]  Title        (star)    |
|             Genre · Movie/Show     |
|             Full description       |
|             Why I like it          |
|             Left off: S2E4  [Resume]|
+------------------------------------+
```
## User story
As the owner, clicking a card opens a larger view with the full description so I can read more and start or resume watching or change favorite status.
## Acceptance
- Opens from any card on any page; backdrop dims the page
- Closes via X, backdrop click, or Escape; focus trapped inside and returned to the card on close
- For shows, a scrollable "Season 1 · N episodes" list under the description (episode number, title, runtime, short summary); the episode you left off on is highlighted; each row has a Play button to jump straight to that episode. The player screen shows the episode title with Previous / Next episode buttons (disabled at the first / last episode)
- Star and progress edits update the rest of the app instantly
- A separate "Watch trailer" button opens a TMDB trailer (YouTube embed) above the details; "Hide trailer" closes it. Titles without a trailer show "No trailer is available for this title."
