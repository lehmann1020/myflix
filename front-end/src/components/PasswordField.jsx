import { useId, useState } from 'react'

// Password input with a Show/Hide button so the user can check what they typed.
export default function PasswordField({ label, hint, invalid = false, ...inputProps }) {
  const id = useId()
  const [visible, setVisible] = useState(false)
  return (
    <div className="auth-field">
      <label htmlFor={id}>{label}</label>
      <div className="password-wrap">
        <input id={id} type={visible ? 'text' : 'password'} aria-invalid={invalid || undefined} {...inputProps} />
        <button
          type="button"
          className="password-toggle"
          aria-pressed={visible}
          aria-label={`${visible ? 'Hide' : 'Show'} ${label.toLowerCase()}`}
          onClick={() => setVisible((v) => !v)}
        >
          {visible ? 'Hide' : 'Show'}
        </button>
      </div>
      {hint}
    </div>
  )
}
