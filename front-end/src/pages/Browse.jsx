import { useMemo, useState } from 'react'
import Card from '../components/Card.jsx'
import { useMyFlix } from '../state/useMyFlix.js'

const TYPES = [
  { value: 'all', label: 'All' },
  { value: 'movie', label: 'Movies' },
  { value: 'show', label: 'Shows' },
]

export default function Browse() {
  const { titles, genreOptions } = useMyFlix()
  const [query, setQuery] = useState('')
  const [type, setType] = useState('all')
  const [genre, setGenre] = useState(null)

  const results = useMemo(() => {
    const q = query.trim().toLowerCase()
    return titles.filter(
      (t) =>
        (type === 'all' || t.type === type) &&
        (!genre || t.genres.includes(genre)) &&
        (!q || t.title.toLowerCase().includes(q) || (t.description ?? '').toLowerCase().includes(q)),
    )
  }, [titles, query, type, genre])

  const filtering = query.trim() !== '' || type !== 'all' || genre !== null
  function clear() {
    setQuery('')
    setType('all')
    setGenre(null)
  }

  return (
    <section className="page browse">
      <h1 className="grid-title">Browse</h1>

      <div className="browse-controls">
        <label className="browse-search">
          <span className="visually-hidden">Search titles</span>
          <input
            type="search"
            placeholder="Search titles"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
        </label>

        <div className="browse-row" role="group" aria-label="Type">
          {TYPES.map((t) => (
            <button
              key={t.value}
              type="button"
              className="genre-chip browse-chip"
              aria-pressed={type === t.value}
              onClick={() => setType(t.value)}
            >
              {t.label}
            </button>
          ))}
        </div>

        <div className="browse-row" role="group" aria-label="Genre">
          <button type="button" className="genre-chip browse-chip" aria-pressed={genre === null} onClick={() => setGenre(null)}>
            All genres
          </button>
          {genreOptions.map((g) => (
            <button
              key={g}
              type="button"
              className="genre-chip browse-chip"
              aria-pressed={genre === g}
              onClick={() => setGenre(genre === g ? null : g)}
            >
              {g}
            </button>
          ))}
        </div>
      </div>

      <p className="browse-count" role="status">
        {results.length} {results.length === 1 ? 'title' : 'titles'}
        {filtering && <> · <button type="button" className="link-button" onClick={clear}>Clear filters</button></>}
      </p>

      {results.length === 0 ? (
        <div className="shelf-empty">
          <p>No titles match. Try a different search or filter.</p>
        </div>
      ) : (
        <div className="card-grid">
          {results.map((item) => <Card key={item.id} item={item} />)}
        </div>
      )}
    </section>
  )
}
