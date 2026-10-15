const EPISODES_PER_SEASON = 8
const MOVIE_STEP_MIN = 20
const MOVIE_LENGTH_MIN = 120

// Returns the next "left off" value after one watch session, or null when a movie is finished.
export function nextProgress(item, current) {
  if (item.type === 'show') {
    const m = /^S(\d+)E(\d+)$/.exec(current ?? '')
    if (!m) return 'S1E1'
    const [season, episode] = [Number(m[1]), Number(m[2])]
    return episode < EPISODES_PER_SEASON ? `S${season}E${episode + 1}` : `S${season + 1}E1`
  }
  const m = /^(\d+):(\d{2}):00$/.exec(current ?? '')
  const minutes = (m ? Number(m[1]) * 60 + Number(m[2]) : 0) + MOVIE_STEP_MIN
  if (minutes >= MOVIE_LENGTH_MIN) return null
  return `${Math.floor(minutes / 60)}:${String(minutes % 60).padStart(2, '0')}:00`
}
