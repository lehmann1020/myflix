import { useEffect, useRef, useState } from 'react'
import { useMyFlix } from '../state/useMyFlix.js'
import { episodeLabel, movieLengthSeconds, toClock, toSeconds } from '../data/progress.js'

export default function PlayerScreen() {
  const { playingId, getTitle } = useMyFlix()
  const item = playingId ? getTitle(playingId) : null
  return item ? <Player key={item.id} item={item} /> : null
}

function Player({ item }) {
  const { playingFrom, setPlayingId, playEpisode, savePosition } = useMyFlix()
  const ref = useRef(null)
  const [closing, setClosing] = useState(false)

  // Movies run a real clock: where you started plus the time actually spent playing (Pause stops it).
  const isMovie = item.type === 'movie'
  const startSeconds = isMovie ? toSeconds(playingFrom) : 0
  const lengthSeconds = isMovie ? movieLengthSeconds(item) : 0
  // `watched` is the milliseconds played before the current run; `resumedAt` is when it started (null while paused).
  const run = useRef({ watched: 0, resumedAt: Date.now() })
  const readElapsed = () => Math.floor((run.current.watched + (run.current.resumedAt ? Date.now() - run.current.resumedAt : 0)) / 1000)
  const [elapsed, setElapsed] = useState(0)
  const [paused, setPaused] = useState(false)
  const position = Math.min(startSeconds + elapsed, lengthSeconds)
  const positionRef = useRef(position)
  positionRef.current = position

  function togglePause() {
    if (run.current.resumedAt) {
      run.current = { watched: run.current.watched + (Date.now() - run.current.resumedAt), resumedAt: null }
      const seconds = readElapsed()
      setElapsed(seconds)
      setPaused(true)
      savePosition(item, Math.min(startSeconds + seconds, lengthSeconds)) // pausing saves where you are
    } else {
      run.current = { ...run.current, resumedAt: Date.now() }
      setPaused(false)
    }
  }

  useEffect(() => {
    const dialog = ref.current
    const opener = document.activeElement
    dialog.showModal()
    return () => {
      if (dialog.open) dialog.close()
      if (opener?.isConnected) opener.focus()
    }
  }, [])

  // Where the playing episode sits in the season, so Previous / Next know their neighbours.
  const labels = item.episodes.map(episodeLabel)
  const index = item.type === 'show' ? labels.indexOf(playingFrom) : -1
  const episode = index >= 0 ? item.episodes[index] : null

  useEffect(() => {
    if (!isMovie) return undefined
    // Date.now() (not a tick counter) so a throttled background tab still counts the real time.
    const tick = setInterval(() => setElapsed(readElapsed()), 1000)
    const autosave = setInterval(() => savePosition(item, positionRef.current), 30000)
    return () => {
      clearInterval(tick)
      clearInterval(autosave)
    }
  }, [isMovie, item, savePosition])

  // The movie ends by itself when the clock reaches the end.
  useEffect(() => {
    if (isMovie && position >= lengthSeconds) close()
  })

  function close() {
    if (closing) return
    if (isMovie) savePosition(item, positionRef.current) // remember exactly how far you got
    const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches
    setClosing(true)
    setTimeout(() => setPlayingId(null), reduce ? 0 : 160)
  }

  return (
    <dialog
      ref={ref}
      className={`player${closing ? ' closing' : ''}`}
      aria-labelledby="player-title"
      onCancel={(e) => { e.preventDefault(); close() }}
    >
      <img className="player-bg" src={item.poster} alt="" />
      <div className="player-content">
        <p className={`player-eq${paused ? ' paused' : ''}`} aria-hidden="true"><i /><i /><i /><i /></p>
        <h2 id="player-title">Playing the {item.title}</h2>
        {isMovie && (
          <p className="player-clock" aria-label={`Time watched, ${toClock(position)} of ${toClock(lengthSeconds)}`}>
            {toClock(position)}
            <span className="player-total"> / {toClock(lengthSeconds)}</span>
          </p>
        )}
        {playingFrom && (
          <p className="player-sub">
            {item.type === 'show' ? 'Episode' : 'From'} {playingFrom}
            {episode && <> · {episode.name}</>}
          </p>
        )}
        {episode && (
          <div className="player-nav">
            <button type="button" className="btn-ghost" disabled={index === 0} onClick={() => playEpisode(item, labels[index - 1])}>
              ← Previous
            </button>
            <button type="button" className="btn-ghost" disabled={index === labels.length - 1} onClick={() => playEpisode(item, labels[index + 1])}>
              Next episode →
            </button>
          </div>
        )}
        <div className="player-controls">
          {isMovie && (
            <button type="button" className="btn-ghost player-pause" aria-pressed={paused} onClick={togglePause}>
              {paused ? 'Resume' : 'Pause'}
            </button>
          )}
          <button type="button" className="btn-primary" onClick={close} autoFocus>Stop</button>
        </div>
      </div>
    </dialog>
  )
}
