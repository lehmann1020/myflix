import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useMyFlix } from '../state/useMyFlix.js'
import { useAuth } from '../state/useAuth.js'

const CONFIRM_WORD = 'DELETE'

export default function Profile() {
  const { profile, genres, favorites, progress } = useMyFlix()
  const { user } = useAuth()
  const inProgress = Object.keys(progress).length

  return (
    <section className="page profile">
      <h1 className="grid-title">Profile</h1>

      <div className="profile-card">
        <dl className="profile-details">
          <div><dt>Name</dt><dd>{profile?.name ?? '—'}</dd></div>
          <div><dt>Email</dt><dd>{profile?.email ?? user?.email}</dd></div>
          <div>
            <dt>Favorite genres</dt>
            <dd>
              {genres.length ? genres.join(', ') : 'None picked yet'}
              {' · '}
              <Link to="/welcome" className="profile-link">Change</Link>
            </dd>
          </div>
          <div><dt>Favorites</dt><dd>{favorites.size}</dd></div>
          <div><dt>In progress</dt><dd>{inProgress}</dd></div>
        </dl>
      </div>

      <DeleteAccount />
    </section>
  )
}

function DeleteAccount() {
  const { deleteAccount } = useAuth()
  const [open, setOpen] = useState(false)
  const [typed, setTyped] = useState('')
  const [deleting, setDeleting] = useState(false)
  const [error, setError] = useState(null)

  // On success the user is cleared and RequireAuth sends us to /login.
  async function onDelete(e) {
    e.preventDefault()
    setDeleting(true)
    setError(null)
    try {
      await deleteAccount()
    } catch (err) {
      setError(err)
      setDeleting(false)
    }
  }

  return (
    <div className="profile-card danger-zone">
      <h2>Delete account</h2>
      <p>
        Permanently deletes your login, favorite genres, favorites and watching progress.
        This can’t be undone.
      </p>

      {!open ? (
        <button type="button" className="btn-danger" onClick={() => setOpen(true)}>Delete my account</button>
      ) : (
        <form className="danger-confirm" onSubmit={onDelete}>
          <label className="auth-field">
            <span>Type {CONFIRM_WORD} to confirm</span>
            <input
              type="text"
              autoComplete="off"
              autoFocus
              value={typed}
              onChange={(e) => setTyped(e.target.value)}
            />
          </label>
          {error && (
            <p className="auth-error" role="alert">
              Your account was not deleted. {error.message.replace(/\.$/, '')}. Try again.
            </p>
          )}
          <div className="danger-actions">
            <button type="submit" className="btn-danger" disabled={typed !== CONFIRM_WORD || deleting}>
              {deleting ? 'Deleting…' : 'Permanently delete'}
            </button>
            <button
              type="button"
              className="btn-ghost"
              disabled={deleting}
              onClick={() => { setOpen(false); setTyped(''); setError(null) }}
            >
              Cancel
            </button>
          </div>
        </form>
      )}
    </div>
  )
}
