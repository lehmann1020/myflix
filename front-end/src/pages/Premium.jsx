import { useState } from 'react'
import { Link } from 'react-router-dom'
import { loadStripe } from '@stripe/stripe-js'
import { Elements, PaymentElement, useElements, useStripe } from '@stripe/react-stripe-js'
import { createPaymentIntent } from '../services/myflixApi.js'
import { useMyFlix } from '../state/useMyFlix.js'

// Only for display and for sizing the card form. The real price is set on the server in
// supabase/functions/create-payment-intent (PREMIUM_AMOUNT_CENTS), so keep the two in step.
const AMOUNT_CENTS = 499
const CURRENCY = 'usd'
const PRICE = new Intl.NumberFormat('en-US', { style: 'currency', currency: CURRENCY }).format(AMOUNT_CENTS / 100)

const PUBLISHABLE_KEY = import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY
const TEST_MODE = PUBLISHABLE_KEY?.startsWith('pk_test_')

// Stripe.js is loaded the first time this page opens, not on every page.
let stripePromise
const getStripe = () => (stripePromise ??= loadStripe(PUBLISHABLE_KEY))

const appearance = {
  theme: 'night',
  variables: {
    colorPrimary: '#f2a33a',
    colorBackground: '#1e1e28',
    colorText: '#f4f1ea',
    colorDanger: '#e5484d',
    borderRadius: '12px',
    fontFamily: 'Inter, system-ui, -apple-system, sans-serif',
  },
}

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

export default function Premium() {
  const { premium } = useMyFlix()

  return (
    <section className="page premium">
      <h1 className="grid-title">Premium</h1>

      {premium ? (
        <div className="profile-card">
          <h2 className="premium-heading">You’re Premium <span aria-hidden="true">★</span></h2>
          <p className="premium-note">Thank you for supporting MyFlix. Your payment is confirmed and nothing more is due.</p>
          <Link to="/" className="btn-primary link-btn">Back to Home</Link>
        </div>
      ) : (
        <div className="profile-card">
          <h2 className="premium-heading">Go Premium</h2>
          <p className="premium-price"><strong>{PRICE}</strong> one-time</p>
          <p className="premium-note">Pay once and your account stays Premium. No subscription, no renewals.</p>

          {!PUBLISHABLE_KEY ? (
            <p className="auth-error" role="alert">
              Payments aren’t set up yet. Add VITE_STRIPE_PUBLISHABLE_KEY to front-end/.env and restart the dev server.
            </p>
          ) : (
            <Elements
              stripe={getStripe()}
              options={{ mode: 'payment', amount: AMOUNT_CENTS, currency: CURRENCY, paymentMethodTypes: ['card'], appearance }}
            >
              <CheckoutForm />
            </Elements>
          )}
        </div>
      )}
    </section>
  )
}

function CheckoutForm() {
  const stripe = useStripe()
  const elements = useElements()
  const { refreshPremium } = useMyFlix()
  const [phase, setPhase] = useState('idle') // idle | paying | confirming | delayed
  const [error, setError] = useState(null)

  async function onSubmit(e) {
    e.preventDefault()
    if (!stripe || !elements) return
    setPhase('paying')
    setError(null)
    try {
      // 1. Stripe checks the card form. The card details never pass through our code.
      const { error: formError } = await elements.submit()
      if (formError) throw formError

      // 2. Our server creates the Payment Intent (price and Stripe secret key stay server-side).
      const { clientSecret } = await createPaymentIntent()

      // 3. The browser confirms it with Stripe directly. 3D Secure, if the bank asks, opens in a popup.
      const { error: payError } = await stripe.confirmPayment({
        elements,
        clientSecret,
        confirmParams: { return_url: `${window.location.origin}/premium` },
        redirect: 'if_required',
      })
      if (payError) throw payError

      // 4. Only the webhook can mark the account Premium, so wait for it to land in the database.
      setPhase('confirming')
      for (let attempt = 0; attempt < 15; attempt++) {
        if (await refreshPremium()) return // the page switches to the confirmed state
        await wait(1500)
      }
      setPhase('delayed')
    } catch (err) {
      if (err.status === 409) refreshPremium().catch(() => {}) // already Premium
      setError(err)
      setPhase('idle')
    }
  }

  if (phase === 'confirming') {
    return <p className="premium-note" role="status">Payment received. Confirming with Stripe…</p>
  }
  if (phase === 'delayed') {
    return (
      <p className="premium-note" role="status">
        Your payment went through, but it’s taking longer than usual to confirm. Refresh this page in a minute and
        Premium will appear. You will not be charged twice.
      </p>
    )
  }

  return (
    <form className="pay-form" onSubmit={onSubmit}>
      {TEST_MODE && <p className="premium-note">Test mode: use card 4242 4242 4242 4242, any future date, any CVC.</p>}
      <PaymentElement />
      {error && <p className="auth-error" role="alert">{error.message}</p>}
      <button type="submit" className="btn-primary" disabled={!stripe || !elements || phase === 'paying'}>
        {phase === 'paying' ? 'Processing…' : `Pay ${PRICE}`}
      </button>
    </form>
  )
}
