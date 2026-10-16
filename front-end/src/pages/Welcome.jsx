import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { GENRES, MAX_GENRES } from '../data/genres.js'
import { useMyFlix } from '../state/useMyFlix.js'

export default function Welcome() {
  const { genres, setGenres } = useMyFlix()
  const navigate = useNavigate()
  const [picked, setPicked] = useState(genres)
  const [nudge, setNudge] = useState(false)
  const ready = picked.length === MAX_GENRES

  function toggle(genre) {
    if (picked.includes(genre)) {
      setPicked(picked.filter((g) => g !== genre))
      setNudge(false)
    } else if (picked.length < MAX_GENRES) {
      setPicked([...picked, genre])
    } else {
      setNudge(true)
    }
  }

  function onContinue() {
    setGenres(picked)
    navigate('/')
  }

  return (
    <main className="welcome">
      <p className="wordmark welcome-mark">MyFlix</p>
      <h1>Welcome to MyFlix</h1>
      <p className="welcome-sub">What are your 3 favorite genres for movies and shows?</p>

      <section className="genre-panel" aria-labelledby="genre-heading">
        <h2 id="genre-heading" className="genre-heading">Pick 3 genres</h2>
        <div className="genre-grid">
          {GENRES.map((genre) => {
            const on = picked.includes(genre)
            return (
              <button
                key={genre}
                type="button"
                className="genre-chip"
                aria-pressed={on}
                onClick={() => toggle(genre)}
              >
                <span className="genre-check" aria-hidden="true">{on ? '✓' : ''}</span>
                {genre}
              </button>
            )
          })}
        </div>
        <p className={`genre-count${nudge ? ' nudge' : ''}`} role="status">
          {nudge ? 'You can pick 3 — deselect one to swap.' : `${picked.length} of ${MAX_GENRES} selected`}
        </p>
      </section>

      <button type="button" className="btn-primary" disabled={!ready} onClick={onContinue}>
        Continue
      </button>
    </main>
  )
}
