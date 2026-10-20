import { useState } from 'react'
import { Link, NavLink, Outlet } from 'react-router-dom'
import { useMyFlix } from '../state/useMyFlix.js'
import { useAuth } from '../state/useAuth.js'
import DetailModal from './DetailModal.jsx'
import PlayerScreen from './PlayerScreen.jsx'

export default function Layout() {
  const { actionError, profile } = useMyFlix()
  const { user, signOut } = useAuth()
  const [signingOut, setSigningOut] = useState(false)
  const [signOutError, setSignOutError] = useState(null)
  const displayName = profile?.name ?? profile?.email ?? user?.email

  // RequireAuth sends us to /login once the user is gone.
  async function onSignOut() {
    setSigningOut(true)
    setSignOutError(null)
    try {
      await signOut()
    } catch (err) {
      setSignOutError(err)
      setSigningOut(false)
    }
  }

  return (
    <>
      <header className="nav">
        <Link to="/" className="wordmark">MyFlix</Link>
        <nav aria-label="Main">
          <NavLink to="/" end>Home</NavLink>
          <NavLink to="/browse">Browse</NavLink>
          <NavLink to="/watching">Watching</NavLink>
          <NavLink to="/favorites">Favorites</NavLink>
        </nav>
        <Link to="/welcome" className="nav-secondary">Change genres</Link>
        <div className="nav-user">
          <NavLink to="/profile" className="nav-user-name" title={user?.email}>{displayName}</NavLink>
          <button type="button" className="btn-ghost" onClick={onSignOut} disabled={signingOut}>
            {signingOut ? 'Logging out…' : 'Log out'}
          </button>
        </div>
      </header>
      <main>
        {signOutError && (
          <p className="status-msg error" role="alert">You were not logged out. {signOutError.message.replace(/\.$/, '')}. Try again.</p>
        )}
        {actionError && (
          <p className="status-msg error" role="alert">Your change was not saved. {actionError.message.replace(/\.$/, '')}. Try again.</p>
        )}
        <Outlet />
      </main>
      <DetailModal />
      <PlayerScreen />
    </>
  )
}
