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

type Result = { id: number; name: string; first_air_date?: string; popularity: number };
type Episode = {
  episode_number: number;
  name: string;
  overview: string;
  runtime: number | null;
  air_date: string | null;
};

async function tmdb(path: string, params: Record<string, string>, apiKey: string) {
  const url = new URL(`${TMDB}${path}`);
  url.searchParams.set("api_key", apiKey);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
  const res = await fetch(url);
  if (!res.ok) throw new Error(`TMDB ${path} failed with ${res.status}`);
  return res.json();
}

// Looks a TV show up by name and first-air year, then returns the episodes of one season.
// Used to load the episodes table; the TMDB key stays in the Supabase secret TMDB_API_KEY.
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
  const season = Number(params.get("season") ?? "1");
  if (!title || !Number.isInteger(season) || season < 1) {
    return json({ error: "Provide 'title' (and optionally 'year' and a whole-number 'season' of 1 or more)." }, 400);
  }

  try {
    const results: Result[] = (
      await tmdb("/search/tv", { query: title, ...(year ? { first_air_date_year: year } : {}) }, apiKey)
    ).results;
    // Prefer an exact name match; otherwise the most popular result.
    const match =
      results.find((r) => r.name.toLowerCase() === title.toLowerCase()) ??
      [...results].sort((a, b) => b.popularity - a.popularity)[0];
    if (!match) return json({ error: "Show not found on TMDB." }, 404);

    const data = await tmdb(`/tv/${match.id}/season/${season}`, { language: "en-US" }, apiKey);
    const episodes = (data.episodes as Episode[]).map((e) => ({
      episode_number: e.episode_number,
      name: e.name,
      overview: e.overview || null,
      runtime_minutes: e.runtime || null,
      air_date: e.air_date || null,
    }));
    return json({
      tmdb_id: match.id,
      tmdb_name: match.name,
      first_air_year: match.first_air_date?.slice(0, 4) ?? null,
      season,
      episodes,
    });
  } catch (err) {
    return json({ error: (err as Error).message }, 502);
  }
});
