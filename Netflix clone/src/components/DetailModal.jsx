import { useEffect, useRef, useState } from 'react'
import { getTitle } from '../data/catalog.js'
import { useMyFlix } from '../state/useMyFlix.js'
import Poster from './Poster.jsx'

export default function DetailModal() {
  const { openId } = useMyFlix()
  const item = openId ? getTitle(openId) : null
  return item ? <Dialog key={item.id} item={item} /> : null
}

function Dialog({ item }) {
  const { favorites, toggleFavorite, progress, watch, notes, setNote, setOpenId } = useMyFlix()
  const ref = useRef(null)
  const [closing, setClosing] = useState(false)
  const isFav = favorites.has(item.id)

  useEffect(() => {
    const dialog = ref.current
    const opener = document.activeElement
    dialog.showModal()
    document.body.style.overflow = 'hidden'
    return () => {
      document.body.style.overflow = ''
      if (dialog.open) dialog.close()
      if (opener?.isConnected) opener.focus()
    }
  }, [])

  function close() {
    if (closing) return
    const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches
    setClosing(true)
    setTimeout(() => setOpenId(null), reduce ? 0 : 140)
  }

  return (
    <dialog
      ref={ref}
      className={`modal${closing ? ' closing' : ''}`}
      aria-labelledby="modal-title"
      onCancel={(e) => { e.preventDefault(); close() }}
      onClick={(e) => { if (e.target === ref.current) close() }}
    >
      <button type="button" className="modal-close" aria-label="Close details" onClick={close}>
        <svg viewBox="0 0 24 24" width="20" height="20" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18" /></svg>
      </button>
      <div className="modal-poster"><Poster id={item.id} title={item.title} hue={item.hue} /></div>
      <div className="modal-body">
        <div className="modal-head">
          <div>
            <h2 id="modal-title">{item.title}</h2>
            <p className="modal-meta">{item.type === 'show' ? 'Show' : 'Movie'} · {item.genres.join(' · ')}</p>
          </div>
          <button
            type="button"
            className={`star static${isFav ? ' on' : ''}`}
            aria-pressed={isFav}
            aria-label={isFav ? `Remove ${item.title} from favorites` : `Add ${item.title} to favorites`}
            onClick={() => toggleFavorite(item.id)}
          >
            <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true">
              <path d="M12 2.5l2.9 6 6.6.9-4.8 4.6 1.2 6.5L12 17.4 6.1 20.5l1.2-6.5L2.5 9.4l6.6-.9z" />
            </svg>
          </button>
        </div>
        <p className="modal-full">{item.full}</p>
        <label className="modal-field">
          <span>Why I like it</span>
          <textarea rows={3} value={notes[item.id] ?? item.why} onChange={(e) => setNote(item.id, e.target.value)} />
        </label>
        <div className="modal-watch">
          <p className="modal-left">Left off <strong>{progress[item.id] ?? 'Not started'}</strong></p>
          <button type="button" className="btn-primary" onClick={() => watch(item)}>
            {progress[item.id] ? 'Resume watching' : 'Start watching'}
          </button>
        </div>
      </div>
    </dialog>
  )
}
