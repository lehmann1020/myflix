import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from '../state/useAuth.js'
import { MyFlixProvider } from '../state/MyFlixContext.jsx'

// Every page inside this route needs a logged-in user. The library is keyed by user id, so logging
// out or switching accounts throws away the previous user's data instead of showing it to the next one.
export default function RequireAuth() {
  const { user, checking } = useAuth()
  const location = useLocation()

  if (checking) {
    return <main><p className="status-msg" role="status">Checking your session…</p></main>
  }
  if (!user) {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />
  }
  return (
    <MyFlixProvider key={user.id}>
      <Outlet />
    </MyFlixProvider>
  )
}
