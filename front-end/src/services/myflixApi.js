// The only place in the app that talks to Supabase (PostgREST over plain fetch).
// Uses the publishable (anon) key from the environment. There is no login yet, so every
// write is owned by the single existing row in `users`, looked up once and cached.

const BASE = `${import.meta.env.VITE_SUPABASE_URL}/rest/v1`
const KEY = import.meta.env.VITE_SUPABASE_ANON_KEY

async function request(path, { method = 'GET', body, prefer } = {}) {
  const headers = {
    apikey: KEY,
    Authorization: `Bearer ${KEY}`,
    'Content-Type': 'application/json',
  }
  if (prefer) headers.Prefer = prefer

  const res = await fetch(`${BASE}${path}`, {
    method,
    headers,
    body: body === undefined ? undefined : JSON.stringify(body),
  })

  // 201/204 responses from writes have empty bodies, so read text and parse only if present.
  const text = await res.text()
  const data = text ? safeJson(text) : null

  if (!res.ok) {
    const detail = data && typeof data === 'object' ? data.message : null
    const err = new Error(`${method} ${path.split('?')[0]} failed (${res.status})${detail ? `: ${detail}` : ''}`)
    err.status = res.status
    err.code = data?.code ?? null
    throw err
  }
  return data
}

function safeJson(text) {
  try {
    return JSON.parse(text)
  } catch {
    return null
  }
}

let userIdPromise = null
function getUserId() {
  if (!userIdPromise) {
    userIdPromise = request('/users?select=id&limit=1')
      .then((rows) => {
        if (!rows?.length) throw new Error('No user row found in the database.')
        return rows[0].id
      })
      .catch((err) => {
        userIdPromise = null // allow a retry on the next call
        throw err
      })
  }
  return userIdPromise
}

// Genre ids are needed when saving picks; filled by loadAll().
let genreIdsByName = new Map()

// Deterministic 0-359 hue from the title id, used by Poster's fallback gradient.
function hueFor(id) {
  let h = 0
  for (let i = 0; i < id.length; i++) h = (h * 31 + id.charCodeAt(i)) | 0
  return Math.abs(h) % 360
}

function toTitle(row) {
  return {
    id: row.id,
    title: row.name,
    type: row.type,
    genres: (row.title_genres ?? []).map((tg) => tg.genres?.name).filter(Boolean).sort(),
    description: row.description,
    full: row.full_description,
    poster: row.poster_url,
    hue: hueFor(row.id),
  }
}

export async function loadAll() {
  const u = await getUserId()
  const [genreRows, titleRows, pickRows, favRows, progressRows] = await Promise.all([
    request('/genres?select=id,name&order=name'),
    request('/titles?select=id,name,type,description,full_description,poster_url,title_genres(genres(name))&order=name'),
    request(`/user_genres?select=pick_order,genres(name)&user_id=eq.${u}&order=pick_order`),
    request(`/favorites?select=title_id&user_id=eq.${u}`),
    request(`/in_progress?select=title_id,left_off&user_id=eq.${u}&finished=eq.false`),
  ])

  genreIdsByName = new Map(genreRows.map((g) => [g.name, g.id]))

  return {
    genreOptions: genreRows.map((g) => g.name),
    titles: titleRows.map(toTitle),
    genres: pickRows.map((p) => p.genres?.name).filter(Boolean),
    favorites: new Set(favRows.map((f) => f.title_id)),
    progress: Object.fromEntries(progressRows.map((p) => [p.title_id, p.left_off])),
  }
}

export async function addFavorite(titleId) {
  const u = await getUserId()
  await request('/favorites', { method: 'POST', body: { user_id: u, title_id: titleId } })
}

export async function removeFavorite(titleId) {
  const u = await getUserId()
  await request(`/favorites?user_id=eq.${u}&title_id=eq.${titleId}`, { method: 'DELETE' })
}

export async function saveProgress(titleId, leftOff) {
  const u = await getUserId()
  await request('/in_progress?on_conflict=user_id,title_id', {
    method: 'POST',
    prefer: 'resolution=merge-duplicates',
    body: { user_id: u, title_id: titleId, left_off: leftOff, finished: false },
  })
}

export async function markFinished(titleId) {
  const u = await getUserId()
  await request(`/in_progress?user_id=eq.${u}&title_id=eq.${titleId}`, {
    method: 'PATCH',
    body: { finished: true },
  })
}

// Replaces the user's picks: delete all, then insert in pick order.
export async function saveGenres(genreNames) {
  const u = await getUserId()
  const rows = genreNames.map((name, i) => {
    const id = genreIdsByName.get(name)
    if (!id) throw new Error(`Unknown genre "${name}".`)
    return { user_id: u, genre_id: id, pick_order: i + 1 }
  })
  await request(`/user_genres?user_id=eq.${u}`, { method: 'DELETE' })
  if (rows.length) await request('/user_genres', { method: 'POST', body: rows })
}
