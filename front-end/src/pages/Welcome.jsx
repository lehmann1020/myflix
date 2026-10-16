import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useMyFlix } from '../state/useMyFlix.js'

const MAX_GENRES = 3

export default function Welcome() {
  const { genreOptions, genres, loading, error } = useMyFlix()

  return (
    <main className="welcome">
      <p className="wordmark welcome-mark">MyFlix</p>
      <h1>Welcome to MyFlix</h1>
      <p className="welcome-sub">What are your 3 favorite genres for movies and shows?</p>

      {loading ? (
        <p className="status-msg" role="status">Loading genres…</p>
      ) : error ? (
        <p className="status-msg error" role="alert">Could not load genres. {error.message.replace(/\.$/, '')}. Refresh the page to try again.</p>
      ) : (
        // Mounted only after loading, so the saved picks are the initial selection.
        <GenrePicker options={genreOptions} saved={genres} />
      )}
    </main>
  )
}

function GenrePicker({ options, saved }) {
  const { setGenres } = useMyFlix()
  const navigate = useNavigate()
  const [picked, setPicked] = useState(saved)
  const [nudge, setNudge] = useState(false)
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState(null)
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

  async function onContinue() {
    setSaving(true)
    setSaveError(null)
    try {
      await setGenres(picked)
      navigate('/')
    } catch (err) {
      setSaveError(err)
      setSaving(false)
    }
  }

  return (
    <>
      <section className="genre-panel" aria-labelledby="genre-heading">
        <h2 id="genre-heading" className="genre-heading">Pick 3 genres</h2>
        <div className="genre-grid">
          {options.map((genre) => {
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

      {saveError && (
        <p className="status-msg error" role="alert">Your genres were not saved. {saveError.message.replace(/\.$/, '')}. Try again.</p>
      )}

      <button type="button" className="btn-primary" disabled={!ready || saving} onClick={onContinue}>
        {saving ? 'Saving…' : 'Continue'}
      </button>
    </>
  )
}
