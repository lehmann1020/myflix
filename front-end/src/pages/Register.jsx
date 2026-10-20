import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../state/useAuth.js'

const MIN_PASSWORD = 6 // Supabase's default minimum

export default function Register() {
  const { signUp } = useAuth()
  const navigate = useNavigate()
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState(null)

  async function onSubmit(e) {
    e.preventDefault()
    setSubmitting(true)
    setError(null)
    try {
      await signUp({ name: name.trim(), email: email.trim(), password })
      navigate('/welcome', { replace: true }) // a new account picks its 3 genres first
    } catch (err) {
      setError(err)
      setSubmitting(false)
    }
  }

  return (
    <main className="welcome">
      <p className="wordmark welcome-mark">MyFlix</p>
      <h1>Create your account</h1>
      <p className="welcome-sub">Your favorites and progress, saved to you.</p>

      <form className="auth-panel" onSubmit={onSubmit}>
        <label className="auth-field">
          <span>Name</span>
          <input type="text" autoComplete="name" required value={name} onChange={(e) => setName(e.target.value)} />
        </label>
        <label className="auth-field">
          <span>Email</span>
          <input type="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        </label>
        <label className="auth-field">
          <span>Password</span>
          <input
            type="password"
            autoComplete="new-password"
            required
            minLength={MIN_PASSWORD}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <small>At least {MIN_PASSWORD} characters.</small>
        </label>

        {error && (
          <p className="auth-error" role="alert">{friendly(error)}</p>
        )}

        <button type="submit" className="btn-primary" disabled={submitting}>
          {submitting ? 'Creating account…' : 'Create account'}
        </button>
      </form>

      <p className="auth-switch">Already have an account? <Link to="/login">Log in</Link></p>
    </main>
  )
}

function friendly(err) {
  if (/already registered/i.test(err.message)) return 'An account with that email already exists. Try logging in.'
  return `${err.message.replace(/\.$/, '')}.`
}
