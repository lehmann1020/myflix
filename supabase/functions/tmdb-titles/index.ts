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
const IMAGE = "https://image.tmdb.org/t/p/w500";

// MyFlix genre -> TMDB genre ids. TMDB has no TV genres for Horror or Romance.
const MOVIE_GENRES: Record<string, string> = {
  Action: "28",
  Comedy: "35",
  Drama: "18",
  Horror: "27",
  Romance: "10749",
  "Sci-Fi": "878",
  Thriller: "53",
};
const SHOW_GENRES: Record<string, string> = {
  Action: "10759",
  Comedy: "35",
  Drama: "18",
  "Sci-Fi": "10765",
  Thriller: "9648|80",
};

// TMDB genre id -> MyFlix genre name, used to tag each title.
const toMyflixGenres = (ids: number[], table: Record<string, string>) =>
  Object.entries(table)
    .filter(([, tmdb]) => tmdb.split("|").some((id) => ids.includes(Number(id))))
    .map(([name]) => name);

// Short card text: the whole overview if it is short, else cut at a word boundary.
const blurb = (overview: string) =>
  overview.length <= 140 ? overview : overview.slice(0, 137).replace(/\s+\S*$/, "") + "...";

type Raw = {
  id: number;
  title?: string;
  name?: string;
  overview: string;
  poster_path: string | null;
  release_date?: string;
  first_air_date?: string;
  genre_ids: number[];
};

async function discover(kind: "movie" | "tv", genre: string, apiKey: string): Promise<Raw[]> {
  const url = new URL(`${TMDB}/discover/${kind}`);
  url.searchParams.set("api_key", apiKey);
  url.searchParams.set("with_genres", genre);
  url.searchParams.set("sort_by", "popularity.desc");
  url.searchParams.set("with_original_language", "en");
  url.searchParams.set("vote_count.gte", "500");
  const res = await fetch(url);
  if (!res.ok) throw new Error(`TMDB ${kind} discover failed with ${res.status}`);
  return (await res.json()).results;
}

async function collect(
  kind: "movie" | "tv",
  table: Record<string, string>,
  total: number,
  apiKey: string,
) {
  const lists = await Promise.all(Object.values(table).map((g) => discover(kind, g, apiKey)));
  const picked = new Map<number, Raw>();
  // Round-robin across genres so each one is represented, skipping duplicates and incomplete entries.
  for (let i = 0; picked.size < total && i < 20; i++) {
    for (const list of lists) {
      const item = list[i];
      if (item && item.poster_path && item.overview && !picked.has(item.id) && picked.size < total) {
        picked.set(item.id, item);
      }
    }
  }
  return [...picked.values()].map((item) => {
    const date = kind === "movie" ? item.release_date : item.first_air_date;
    return {
      name: (kind === "movie" ? item.title : item.name) as string,
      type: kind === "movie" ? "movie" : "show",
      description: blurb(item.overview),
      full_description: item.overview,
      poster_url: IMAGE + item.poster_path,
      release_year: date ? Number(date.slice(0, 4)) : null,
      genres: toMyflixGenres(item.genre_ids, table),
    };
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const apiKey = Deno.env.get("TMDB_API_KEY");
  if (!apiKey) {
    return json({ error: "TMDB_API_KEY secret is not set." }, 500);
  }

  const count = Math.min(Math.max(Number(new URL(req.url).searchParams.get("count")) || 20, 1), 40);

  try {
    const [movies, shows] = await Promise.all([
      collect("movie", MOVIE_GENRES, count, apiKey),
      collect("tv", SHOW_GENRES, count, apiKey),
    ]);
    return json({ titles: [...movies, ...shows] });
  } catch (err) {
    return json({ error: (err as Error).message }, 502);
  }
});
