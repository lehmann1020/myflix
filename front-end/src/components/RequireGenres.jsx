import { Navigate, Outlet } from 'react-router-dom'
import { useMyFlix } from '../state/useMyFlix.js'

export default function RequireGenres() {
  const { genres } = useMyFlix()
  return genres.length === 3 ? <Outlet /> : <Navigate to="/welcome" replace />
}
