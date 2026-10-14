# Page: Welcome (`/welcome`)
Wireframe: top frame of `../app.png`.

```
+--------------------------------------------+
|           Welcome to MyFlix                |
|  What are your 3 favorite genres ...       |
|   +------------------------------------+   |
|   |  List of genres (7 selectable)     |   |
|   +------------------------------------+   |
|              [ Continue ]                  |
+--------------------------------------------+
```
## User story
As the owner, on first load I pick exactly 3 of 7 genres (Action, Comedy, Drama, Sci-Fi, Horror, Romance, Thriller) so MyFlix can recommend titles.
## Acceptance
- Genres toggle on click/keyboard; selected state has check + color
- 4th pick is blocked (with a short hint) until one is deselected; counter shows "2 of 3"
- Continue disabled until exactly 3; then routes to `/` with genres in state
- Visiting any other route with no genres redirects here
