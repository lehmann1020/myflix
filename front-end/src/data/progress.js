const MOVIE_STEP_MIN = 20
const MOVIE_LENGTH_MIN = 120

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
//  - Movies advance 20 minutes per watch and finish at 2:00:00.
export function nextProgress(item, current) {
  if (item.type === 'show') {
    const labels = (item.episodes ?? []).map(episodeLabel)
    const next = labels[labels.indexOf(current) + 1] // not started (or unknown) -> the first episode
    if (!next) return { playingFrom: current ?? null, saved: null }
    return { playingFrom: next, saved: next === labels[labels.length - 1] ? null : next }
  }
  const m = /^(\d+):(\d{2}):00$/.exec(current ?? '')
  const minutes = (m ? Number(m[1]) * 60 + Number(m[2]) : 0) + MOVIE_STEP_MIN
  return {
    playingFrom: current ?? '0:00:00',
    saved: minutes >= MOVIE_LENGTH_MIN ? null : `${Math.floor(minutes / 60)}:${String(minutes % 60).padStart(2, '0')}:00`,
  }
}
