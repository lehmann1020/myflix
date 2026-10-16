# Page: Home (`/`)
Wireframe: bottom frame of `../app.png`.

```
+--------------------------------------------+
| MyFlix        Home  Watching  Favorites    |
| I think you'd like                         |
| <  [card][card][card][card][card]  >       |
| Continue watching                          |
| <  [card][card][card][card][card]  >       |
+--------------------------------------------+
```
## User story
As the owner, I see titles matching my genres and a shelf to resume what I'm watching, scrolling each row with arrows.
## Acceptance
- "I think you'd like" shows only titles with a genre in my 3 picks
- "Continue watching" shows titles with progress; empty state: "Nothing in progress — add where you left off on any title."
- Arrows scroll a page of cards smoothly, disable/hide at ends; rows also scroll by touch/trackpad
- Card: poster, title, short description, star, read-only "Left off" with Watch/Resume button; hover highlights; click opens modal
- Pressing Watch adds the card to Continue watching immediately; finishing a movie removes it
