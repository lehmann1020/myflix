import { useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../state/useAuth.js'

export default function Login() {
  const { signIn } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState(null)

  async function onSubmit(e) {
    e.preventDefault()
    setSubmitting(true)
    setError(null)
    try {
      await signIn({ email: email.trim(), password })
      navigate(location.state?.from ?? '/', { replace: true })
    } catch (err) {
      setError(err)
      setSubmitting(false)
    }
  }

  return (
    <main className="welcome">
      <p className="wordmark welcome-mark">MyFlix</p>
      <h1>Welcome back</h1>
      <p className="welcome-sub">Log in to pick up where you left off.</p>

      <form className="auth-panel" onSubmit={onSubmit}>
        <label className="auth-field">
          <span>Email</span>
          <input type="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        </label>
        <label className="auth-field">
          <span>Password</span>
          <input type="password" autoComplete="current-password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        </label>

        {error && (
          <p className="auth-error" role="alert">{friendly(error)}</p>
        )}

        <button type="submit" className="btn-primary" disabled={submitting}>
          {submitting ? 'Logging in…' : 'Log in'}
        </button>
      </form>

      <p className="auth-switch">New to MyFlix? <Link to="/register">Create an account</Link></p>
    </main>
  )
}

function friendly(err) {
  if (/invalid login credentials/i.test(err.message)) return 'That email and password don’t match an account.'
  return `${err.message.replace(/\.$/, '')}.`
}
