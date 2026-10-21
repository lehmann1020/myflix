import Stripe from "npm:stripe@17.7.0";
import { createClient } from "npm:@supabase/supabase-js@2";

// Stripe calls this function, not a logged-in user, so it is deployed without JWT verification.
// Its proof of identity is Stripe's signature, checked below with STRIPE_WEBHOOK_SECRET.
// It writes with the service-role key (injected by Supabase at runtime, never stored in the repo or .env).
// The webhook is the source of truth for payments: the browser never tells the database anything.

const cryptoProvider = Stripe.createSubtleCryptoProvider();

const reply = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return reply({ error: "Use POST." }, 405);
  }

  const stripeKey = Deno.env.get("STRIPE_SECRET_KEY");
  const webhookSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET");
  if (!stripeKey || !webhookSecret) {
    return reply({ error: "STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET secrets must be set." }, 500);
  }
  const signature = req.headers.get("stripe-signature");
  if (!signature) {
    return reply({ error: "Missing stripe-signature header." }, 400);
  }
  const stripe = new Stripe(stripeKey, { httpClient: Stripe.createFetchHttpClient() });

  // The signature covers the exact raw body, so read it as text before anything parses it.
  const body = await req.text();
  let event: Stripe.Event;
  try {
    event = await stripe.webhooks.constructEventAsync(body, signature, webhookSecret, undefined, cryptoProvider);
  } catch {
    return reply({ error: "Invalid signature." }, 400);
  }

  if (event.type !== "payment_intent.succeeded" && event.type !== "payment_intent.payment_failed") {
    return reply({ received: true, ignored: event.type });
  }

  const intent = event.data.object as Stripe.PaymentIntent;
  const userId = intent.metadata?.user_id;
  if (!userId || intent.metadata?.product !== "premium") {
    return reply({ received: true, ignored: "not a MyFlix premium payment" });
  }

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const succeeded = event.type === "payment_intent.succeeded";
  const row = {
    user_id: userId,
    stripe_payment_intent_id: intent.id,
    amount: intent.amount,
    currency: intent.currency,
    status: succeeded ? "succeeded" : "failed",
  };

  // Idempotent: Stripe can deliver an event twice or out of order. The unique intent id means a repeat
  // changes nothing, "succeeded" always wins, and a late "failed" never overwrites a success.
  const { error } = await admin
    .from("payments")
    .upsert(row, { onConflict: "stripe_payment_intent_id", ignoreDuplicates: !succeeded });

  if (error) {
    // 23503: the user was deleted before the event arrived. Nothing to record, so don't make Stripe retry.
    if (error.code === "23503") return reply({ received: true, ignored: "user no longer exists" });
    console.error("stripe-webhook could not save the payment:", error.code, error.message);
    return reply({ error: "Could not save the payment." }, 500); // non-2xx makes Stripe retry
  }
  return reply({ received: true });
});
