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

type Result = { id: number; title?: string; name?: string; popularity: number };
type Video = { key: string; name: string; site: string; type: string; official: boolean };

async function tmdb(path: string, params: Record<string, string>, apiKey: string) {
  const url = new URL(`${TMDB}${path}`);
  url.searchParams.set("api_key", apiKey);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
  const res = await fetch(url);
  if (!res.ok) throw new Error(`TMDB ${path} failed with ${res.status}`);
  return res.json();
}

// Official trailer first, then any trailer, then a teaser. Only YouTube videos can be embedded.
const rank = (v: Video) => (v.type === "Trailer" ? 0 : v.type === "Teaser" ? 2 : 9) + (v.official ? 0 : 1);

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
  const type = params.get("type");
  const year = params.get("year");
  if (!title || (type !== "movie" && type !== "show")) {
    return json({ error: "Provide 'title' and 'type' (movie or show). 'year' is optional." }, 400);
  }

  const kind = type === "movie" ? "movie" : "tv";

  try {
    const search = { query: title, ...(year ? { [kind === "movie" ? "year" : "first_air_date_year"]: year } : {}) };
    const results: Result[] = (await tmdb(`/search/${kind}`, search, apiKey)).results;
    // Prefer an exact name match; otherwise the most popular result.
    const match =
      results.find((r) => (r.title ?? r.name)?.toLowerCase() === title.toLowerCase()) ??
      [...results].sort((a, b) => b.popularity - a.popularity)[0];
    if (!match) return json({ error: "Title not found on TMDB." }, 404);

    const videos: Video[] = (await tmdb(`/${kind}/${match.id}/videos`, { language: "en-US" }, apiKey)).results;
    const best = videos.filter((v) => v.site === "YouTube").sort((a, b) => rank(a) - rank(b))[0];
    if (!best) return json({ error: "No trailer available for this title." }, 404);

    return json({ key: best.key, name: best.name, type: best.type });
  } catch (err) {
    return json({ error: (err as Error).message }, 502);
  }
});
