const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

const TMDB = "https://api.themoviedb.org/3";

type Result = { id: number; title: string; release_date?: string; popularity: number };

async function tmdb(path: string, params: Record<string, string>, apiKey: string) {
  const url = new URL(`${TMDB}${path}`);
  url.searchParams.set("api_key", apiKey);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
  const res = await fetch(url);
  if (!res.ok) throw new Error(`TMDB ${path} failed with ${res.status}`);
  return res.json();
}

// Looks a movie up by name and release year and returns its runtime in minutes.
// Used to fill titles.runtime_minutes; the TMDB key stays in the Supabase secret TMDB_API_KEY.
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const apiKey = Deno.env.get("TMDB_API_KEY");
  if (!apiKey) {
    return json({ error: "TMDB_API_KEY secret is not set." }, 500);
  }

  const params = new URL(req.url).searchParams;
  const title = params.get("title")?.trim();
  const year = params.get("year");
  if (!title) {
    return json({ error: "Provide 'title' (and optionally 'year')." }, 400);
  }

  try {
    const results: Result[] = (await tmdb("/search/movie", { query: title, ...(year ? { year } : {}) }, apiKey)).results;
    // Prefer an exact name match; otherwise the most popular result.
    const match =
      results.find((r) => r.title.toLowerCase() === title.toLowerCase()) ??
      [...results].sort((a, b) => b.popularity - a.popularity)[0];
    if (!match) return json({ error: "Movie not found on TMDB." }, 404);

    const movie = await tmdb(`/movie/${match.id}`, { language: "en-US" }, apiKey);
    return json({
      tmdb_id: match.id,
      tmdb_title: match.title,
      release_year: match.release_date?.slice(0, 4) ?? null,
      runtime_minutes: movie.runtime || null,
    });
  } catch (err) {
    return json({ error: (err as Error).message }, 502);
  }
});
