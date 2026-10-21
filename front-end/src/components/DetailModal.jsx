import { useEffect, useRef, useState } from 'react'
import { useMyFlix } from '../state/useMyFlix.js'
import { getTrailer } from '../services/myflixApi.js'
import Poster from './Poster.jsx'

export default function DetailModal() {
  const { openId, getTitle } = useMyFlix()
  const item = openId ? getTitle(openId) : null
  return item ? <Dialog key={item.id} item={item} /> : null
}

function Dialog({ item }) {
  const { favorites, toggleFavorite, progress, watch, setOpenId } = useMyFlix()
  const ref = useRef(null)
  const [closing, setClosing] = useState(false)
  const [showTrailer, setShowTrailer] = useState(false)
  const [trailer, setTrailer] = useState(null) // null until first requested, then { status, key?, name?, message? }
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

  // The trailer is looked up the first time it is opened, then reused.
  function toggleTrailer() {
    if (showTrailer) return setShowTrailer(false)
    setShowTrailer(true)
    if (trailer?.status === 'ready' || trailer?.status === 'loading') return
    setTrailer({ status: 'loading' })
    getTrailer({ title: item.title, type: item.type, year: item.year })
      .then((t) => setTrailer({ status: 'ready', key: t.key, name: t.name }))
      .catch((err) => setTrailer({ status: 'error', message: err.status === 404 ? 'No trailer is available for this title.' : 'Could not load the trailer. Try again.' }))
  }

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
      {showTrailer && (
        <div className="modal-trailer" aria-live="polite">
          {trailer?.status === 'ready' ? (
            <>
              <p className="trailer-bar">{trailer.name}</p>
              <div className="trailer-frame">
                <iframe
                  src={`https://www.youtube-nocookie.com/embed/${trailer.key}?autoplay=1&rel=0`}
                  title={`${item.title}: ${trailer.name}`}
                  allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
                />
              </div>
            </>
          ) : (
            <p className={trailer?.status === 'error' ? 'trailer-msg error' : 'trailer-msg'}>
              {trailer?.status === 'error' ? trailer.message : 'Loading trailer…'}
            </p>
          )}
        </div>
      )}
      <div className="modal-poster"><Poster src={item.poster} title={item.title} hue={item.hue} /></div>
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
        <div className="modal-watch">
          <p className="modal-left">Left off <strong>{progress[item.id] ?? 'Not started'}</strong></p>
          <div className="modal-actions">
            <button type="button" className="btn-ghost" aria-expanded={showTrailer} onClick={toggleTrailer}>
              {showTrailer ? 'Hide trailer' : 'Watch trailer'}
            </button>
            <button type="button" className="btn-primary" onClick={() => watch(item)}>
              {progress[item.id] ? 'Resume watching' : 'Start watching'}
            </button>
          </div>
        </div>
      </div>
    </dialog>
  )
}
