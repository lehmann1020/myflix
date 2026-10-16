import { Link, NavLink, Outlet } from 'react-router-dom'
import { useMyFlix } from '../state/useMyFlix.js'
import DetailModal from './DetailModal.jsx'
import PlayerScreen from './PlayerScreen.jsx'

export default function Layout() {
  const { actionError } = useMyFlix()
  return (
    <>
      <header className="nav">
        <Link to="/" className="wordmark">MyFlix</Link>
        <nav aria-label="Main">
          <NavLink to="/" end>Home</NavLink>
          <NavLink to="/watching">Watching</NavLink>
          <NavLink to="/favorites">Favorites</NavLink>
        </nav>
        <Link to="/welcome" className="nav-secondary">Change genres</Link>
      </header>
      <main>
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
