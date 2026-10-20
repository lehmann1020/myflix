import { Navigate, Outlet } from 'react-router-dom'
import { useAuth } from '../state/useAuth.js'

// Log in and Register are only for logged-out visitors; a logged-in user goes to the app.
export default function GuestOnly() {
  const { user, checking } = useAuth()
  if (checking) {
    return <main><p className="status-msg" role="status">Checking your session…</p></main>
  }
  return user ? <Navigate to="/" replace /> : <Outlet />
}
