import { useEffect, useRef, useState } from 'react'
import { useMyFlix } from '../state/useMyFlix.js'
import { episodeLabel } from '../data/progress.js'

export default function PlayerScreen() {
  const { playingId, getTitle } = useMyFlix()
  const item = playingId ? getTitle(playingId) : null
  return item ? <Player key={item.id} item={item} /> : null
}

function Player({ item }) {
  const { playingFrom, setPlayingId, playEpisode } = useMyFlix()
  const ref = useRef(null)
  const [closing, setClosing] = useState(false)

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

  function close() {
    if (closing) return
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
        <p className="player-eq" aria-hidden="true"><i /><i /><i /><i /></p>
        <h2 id="player-title">Playing the {item.title}</h2>
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
        <button type="button" className="btn-primary" onClick={close} autoFocus>Stop</button>
      </div>
    </dialog>
  )
}
