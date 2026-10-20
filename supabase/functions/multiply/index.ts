const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

const toNumber = (value: unknown): number | null => {
  if (typeof value === "number") return Number.isFinite(value) ? value : null;
  if (typeof value === "string" && value.trim() !== "") {
    const n = Number(value);
    return Number.isFinite(n) ? n : null;
  }
  return null;
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Accept ?a=&b= in the query string and/or {"a":..,"b":..} in a JSON body.
  const params = new URL(req.url).searchParams;
  let a: unknown = params.get("a");
  let b: unknown = params.get("b");

  if (req.method === "POST") {
    const text = await req.text();
    if (text.trim() !== "") {
      try {
        const body = JSON.parse(text);
        a = body?.a ?? a;
        b = body?.b ?? b;
      } catch {
        return json({ error: "Request body must be valid JSON." }, 400);
      }
    }
  }

  if (a === null || a === undefined || b === null || b === undefined) {
    return json({ error: "Both 'a' and 'b' are required (query string or JSON body)." }, 400);
  }

  const x = toNumber(a);
  const y = toNumber(b);
  if (x === null || y === null) {
    return json({ error: "'a' and 'b' must be valid numbers." }, 400);
  }

  return json({ result: x * y });
});
