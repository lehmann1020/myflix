import Stripe from "npm:stripe@17.7.0";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

// The price lives on the server so the browser can never choose its own amount.
const PREMIUM_AMOUNT_CENTS = 499;
const CURRENCY = "usd";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return json({ error: "Use POST." }, 405);
  }

  // Act as the logged-in user: their token decides who they are and what RLS lets them read.
  const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } },
  });
  const { data: { user }, error: userError } = await supabase.auth.getUser();
  if (userError || !user) {
    return json({ error: "You must be logged in." }, 401);
  }

  const { data: paid, error: paidError } = await supabase
    .from("payments")
    .select("id")
    .eq("status", "succeeded")
    .limit(1);
  if (paidError) {
    return json({ error: "Could not check your account." }, 500);
  }
  if (paid && paid.length > 0) {
    return json({ error: "You already have Premium." }, 409);
  }

  const stripeKey = Deno.env.get("STRIPE_SECRET_KEY");
  if (!stripeKey) {
    return json({ error: "STRIPE_SECRET_KEY secret is not set." }, 500);
  }

  try {
    const stripe = new Stripe(stripeKey, { httpClient: Stripe.createFetchHttpClient() });
    const intent = await stripe.paymentIntents.create({
      amount: PREMIUM_AMOUNT_CENTS,
      currency: CURRENCY,
      // Cards only, so 3D Secure happens in a popup and no redirect is needed.
      automatic_payment_methods: { enabled: true, allow_redirects: "never" },
      description: "MyFlix Premium (one-time)",
      metadata: { user_id: user.id, product: "premium" },
    });
    return json({ clientSecret: intent.client_secret, amount: PREMIUM_AMOUNT_CENTS, currency: CURRENCY });
  } catch (err) {
    console.error("create-payment-intent failed:", (err as Error).message);
    return json({ error: "Could not start the payment." }, 502);
  }
});
