// A movie finishes at its real runtime (titles.runtime_minutes); 2 hours if one is missing.
const DEFAULT_MOVIE_MINUTES = 120
export const movieLengthSeconds = (item) => (item.runtime ?? DEFAULT_MOVIE_MINUTES) * 60

// "2h 49m" for a runtime in minutes.
export function formatRuntime(minutes) {
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  return h ? `${h}h ${m}m` : `${m}m`
}

// "H:MM:SS" <-> seconds. Older saved positions like "0:20:00" parse fine.
export function toSeconds(clock) {
  const m = /^(\d+):(\d{2}):(\d{2})$/.exec(clock ?? '')
  return m ? Number(m[1]) * 3600 + Number(m[2]) * 60 + Number(m[3]) : 0
}
export function toClock(seconds) {
  const s = Math.max(0, Math.floor(seconds))
  return `${Math.floor(s / 3600)}:${String(Math.floor((s % 3600) / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`
}

// The "left off" value to save for a movie at this many seconds in, or null once it has reached the end.
export const moviePosition = (item, seconds) => (seconds >= movieLengthSeconds(item) ? null : toClock(seconds))

// "S1E3" style label for one of a show's episodes.
export const episodeLabel = (episode) => `S${episode.season}E${episode.number}`

// The session for playing a specific episode (picked from the list or with Previous / Next). Same rule as
// above: starting the last episode finishes the show.
export function episodeSession(item, label) {
  const labels = item.episodes.map(episodeLabel)
  return { playingFrom: label, saved: label === labels[labels.length - 1] ? null : label }
}

// What one watch session does. `playingFrom` is where playback starts (shown on the player screen) and
// `saved` is the new "left off" value, or null once the title is finished.
//  - Shows play their real episodes in order (Season 1, from the episodes table). Starting the last episode
//    finishes the show, the same way the last 20-minute chunk finishes a movie.
//  - Movies play from where they were left (0:00:00 if new). The player runs a real clock and saves the exact
//    position when you stop, so nothing is advanced here; it only makes sure the movie is on Continue watching.
//    The movie finishes at its runtime.
export function nextProgress(item, current) {
  if (item.type === 'show') {
    const labels = (item.episodes ?? []).map(episodeLabel)
    const next = labels[labels.indexOf(current) + 1] // not started (or unknown) -> the first episode
    if (!next) return { playingFrom: current ?? null, saved: null }
    return { playingFrom: next, saved: next === labels[labels.length - 1] ? null : next }
  }
  const start = current ?? '0:00:00'
  return { playingFrom: start, saved: start }
}
