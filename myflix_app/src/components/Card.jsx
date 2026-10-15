import { useMyFlix } from '../state/useMyFlix.js'
import Poster from './Poster.jsx'

export default function Card({ item }) {
  const { favorites, toggleFavorite, progress, watch, setOpenId } = useMyFlix()
  const isFav = favorites.has(item.id)

  return (
    <article className="card">
      <div className="card-media">
        <button type="button" className="card-open" onClick={() => setOpenId(item.id)} aria-label={`Open details for ${item.title}`}>
          <Poster id={item.id} title={item.title} hue={item.hue} />
        </button>
        <button
          type="button"
          className={`star${isFav ? ' on' : ''}`}
          aria-pressed={isFav}
          aria-label={isFav ? `Remove ${item.title} from favorites` : `Add ${item.title} to favorites`}
          onClick={() => toggleFavorite(item.id)}
        >
          <svg viewBox="0 0 24 24" width="20" height="20" aria-hidden="true">
            <path d="M12 2.5l2.9 6 6.6.9-4.8 4.6 1.2 6.5L12 17.4 6.1 20.5l1.2-6.5L2.5 9.4l6.6-.9z" />
          </svg>
        </button>
        <span className="card-type">{item.type === 'show' ? 'Show' : 'Movie'}</span>
      </div>
      <div className="card-body">
        <h3 className="card-title">{item.title}</h3>
        <p className="card-desc">{item.description}</p>
        <div className="progress">
          <span className="progress-label">
            {progress[item.id] ? <><span className="sr-only">Left off</span><strong>{progress[item.id]}</strong></> : 'Not started'}
          </span>
          <button type="button" className="watch-btn" onClick={() => watch(item)} aria-label={`Watch ${item.title}`}>
            <svg viewBox="0 0 24 24" width="14" height="14" aria-hidden="true"><path d="M7 4.5v15l12-7.5z" /></svg>
            {progress[item.id] ? 'Resume' : 'Watch'}
          </button>
        </div>
      </div>
    </article>
  )
}
