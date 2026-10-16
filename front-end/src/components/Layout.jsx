import { Link, NavLink, Outlet } from 'react-router-dom'
import DetailModal from './DetailModal.jsx'
import PlayerScreen from './PlayerScreen.jsx'

export default function Layout() {
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
        <Outlet />
      </main>
      <DetailModal />
      <PlayerScreen />
    </>
  )
}
