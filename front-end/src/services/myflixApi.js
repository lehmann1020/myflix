// The only place in the app that talks to Supabase.
// Auth goes through supabase-js (it stores the session in localStorage and refreshes the token).
// Table data goes through PostgREST over plain fetch, sent with the logged-in user's access token.
// Uses the publishable (anon) key only. The database fills in every user_id from the token
// (default auth.uid()) and RLS limits each user to their own rows, so the app never sends a user id.
import { createClient } from '@supabase/supabase-js'

const URL = import.meta.env.VITE_SUPABASE_URL
const KEY = import.meta.env.VITE_SUPABASE_ANON_KEY
const BASE = `${URL}/rest/v1`

const supabase = createClient(URL, KEY)

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

function authError(error) {
  const err = new Error(error.message)
  err.status = error.status ?? null
  err.code = error.code ?? null
  return err
}

// Register. `name` is stored in the auth metadata; the database trigger copies it into public.users.
export async function signUp({ name, email, password }) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { name } },
  })
  if (error) throw authError(error)
  // With "Confirm email" on, Supabase returns a user but no session.
  if (!data.session) throw new Error('Check your email to confirm your account, then log in.')
  return data.session
}

export async function signIn({ email, password }) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password })
  if (error) throw authError(error)
  return data.session
}

// Ends the session and removes the stored tokens from this browser.
export async function signOut() {
  const { error } = await supabase.auth.signOut()
  if (error) throw authError(error)
}

// Recovers the session saved in this browser (e.g. after a refresh) and confirms it with Supabase.
// Returns the user, or null if nobody is logged in or the saved session is no longer valid.
export async function getCurrentUser() {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) return null
  const { data, error } = await supabase.auth.getUser()
  if (error) {
    await supabase.auth.signOut({ scope: 'local' })
    return null
  }
  return data.user
}

// Calls `callback(user | null)` when the user logs in, logs out, or the session ends.
// Returns an unsubscribe function.
export function onAuthChange(callback) {
  const { data } = supabase.auth.onAuthStateChange((event, session) => {
    if (event === 'INITIAL_SESSION') return // getCurrentUser() handles the first load
    callback(session?.user ?? null)
  })
  return () => data.subscription.unsubscribe()
}

// ---------------------------------------------------------------------------
// Table data
// ---------------------------------------------------------------------------

async function request(path, { method = 'GET', body, prefer } = {}) {
  // getSession() returns a fresh access token, refreshing it first if it has expired.
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) {
    const err = new Error('You are not logged in')
    err.status = 401
    throw err
  }

  const headers = {
    apikey: KEY,
    Authorization: `Bearer ${session.access_token}`,
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

// RLS returns only the logged-in user's rows, so the per-user queries need no user filter.
export async function loadAll() {
  const [profileRows, genreRows, titleRows, pickRows, favRows, progressRows] = await Promise.all([
    request('/users?select=name,email'),
    request('/genres?select=id,name&order=name'),
    request('/titles?select=id,name,type,description,full_description,poster_url,title_genres(genres(name))&order=name'),
    request('/user_genres?select=pick_order,genres(name)&order=pick_order'),
    request('/favorites?select=title_id'),
    request('/in_progress?select=title_id,left_off&finished=eq.false'),
  ])

  genreIdsByName = new Map(genreRows.map((g) => [g.name, g.id]))

  return {
    profile: profileRows[0] ?? null,
    genreOptions: genreRows.map((g) => g.name),
    titles: titleRows.map(toTitle),
    genres: pickRows.map((p) => p.genres?.name).filter(Boolean),
    favorites: new Set(favRows.map((f) => f.title_id)),
    progress: Object.fromEntries(progressRows.map((p) => [p.title_id, p.left_off])),
  }
}

export async function addFavorite(titleId) {
  await request('/favorites', { method: 'POST', body: { title_id: titleId } })
}

export async function removeFavorite(titleId) {
  await request(`/favorites?title_id=eq.${titleId}`, { method: 'DELETE' })
}

export async function saveProgress(titleId, leftOff) {
  await request('/in_progress?on_conflict=user_id,title_id', {
    method: 'POST',
    prefer: 'resolution=merge-duplicates',
    body: { title_id: titleId, left_off: leftOff, finished: false },
  })
}

export async function markFinished(titleId) {
  await request(`/in_progress?title_id=eq.${titleId}`, {
    method: 'PATCH',
    body: { finished: true },
  })
}

// Replaces the user's picks: delete all, then insert in pick order.
export async function saveGenres(genreNames) {
  const rows = genreNames.map((name, i) => {
    const id = genreIdsByName.get(name)
    if (!id) throw new Error(`Unknown genre "${name}".`)
    return { genre_id: id, pick_order: i + 1 }
  })
  await request('/user_genres?pick_order=gte.1', { method: 'DELETE' })
  if (rows.length) await request('/user_genres', { method: 'POST', body: rows })
}
