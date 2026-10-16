import { Navigate, Outlet } from 'react-router-dom'
import { useMyFlix } from '../state/useMyFlix.js'

export default function RequireGenres() {
  const { genres, loading, error } = useMyFlix()
  if (loading) {
    return <main><p className="status-msg" role="status">Loading your library…</p></main>
  }
  if (error) {
    return (
      <main>
        <p className="status-msg error" role="alert">Could not load your library. {error.message.replace(/\.$/, '')}. Refresh the page to try again.</p>
      </main>
    )
  }
  return genres.length === 3 ? <Outlet /> : <Navigate to="/welcome" replace />
}
