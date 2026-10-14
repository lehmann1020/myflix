import { useEffect, useRef, useState } from 'react'
import { getTitle } from '../data/catalog.js'
import { useMyFlix } from '../state/useMyFlix.js'

export default function PlayerScreen() {
  const { playingId } = useMyFlix()
  const item = playingId ? getTitle(playingId) : null
  return item ? <Player key={item.id} item={item} /> : null
}

function Player({ item }) {
  const { progress, setPlayingId } = useMyFlix()
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
      <img className="player-bg" src={`/posters/${item.id}.jpg`} alt="" />
      <div className="player-content">
        <p className="player-eq" aria-hidden="true"><i /><i /><i /><i /></p>
        <h2 id="player-title">Playing the {item.title}</h2>
        {progress[item.id] && <p className="player-sub">{item.type === 'show' ? 'Episode' : 'From'} {progress[item.id]}</p>}
        <button type="button" className="btn-primary" onClick={close} autoFocus>Stop</button>
      </div>
    </dialog>
  )
}
