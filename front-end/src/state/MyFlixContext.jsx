import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { MyFlixContext } from './context.js'
import { nextProgress } from '../data/progress.js'
import * as api from '../services/myflixApi.js'

// State is loaded from Supabase on mount (the database is the source of truth).
// Favorites and progress update optimistically and roll back if the write fails.
export function MyFlixProvider({ children }) {
  const [titles, setTitles] = useState([])
  const [genreOptions, setGenreOptions] = useState([])
  const [genres, setGenresState] = useState([])
  const [favorites, setFavorites] = useState(() => new Set())
  const [progress, setProgress] = useState({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [actionError, setActionError] = useState(null)
  const [openId, setOpenId] = useState(null)
  const [playingId, setPlayingId] = useState(null)

  // Mirrors of the latest state so handlers can read it synchronously (rapid clicks).
  const favRef = useRef(favorites)
  const progressRef = useRef(progress)
  // Per-title queues so writes for the same title never race each other.
  const queues = useRef(new Map())
  const started = useRef(false)

  useEffect(() => {
    // StrictMode mounts effects twice in dev; load only once.
    if (started.current) return
    started.current = true
    api
      .loadAll()
      .then((data) => {
        favRef.current = data.favorites
        progressRef.current = data.progress
        setTitles(data.titles)
        setGenreOptions(data.genreOptions)
        setGenresState(data.genres)
        setFavorites(data.favorites)
        setProgress(data.progress)
      })
      .catch((err) => setError(err))
      .finally(() => setLoading(false))
  }, [])

  const enqueue = useCallback((key, task) => {
    const prev = queues.current.get(key) ?? Promise.resolve()
    const next = prev.then(task, task)
    queues.current.set(key, next)
    return next
  }, [])

  const applyFavorites = (next) => {
    favRef.current = next
    setFavorites(next)
  }

  const applyProgress = (next) => {
    progressRef.current = next
    setProgress(next)
  }

  const toggleFavorite = useCallback((id) => {
    setActionError(null)
    const wasFav = favRef.current.has(id)
    const next = new Set(favRef.current)
    if (wasFav) next.delete(id)
    else next.add(id)
    applyFavorites(next)

    enqueue(`fav:${id}`, () => (wasFav ? api.removeFavorite(id) : api.addFavorite(id))).catch((err) => {
      // Roll back only if nothing newer has changed this title since.
      if (favRef.current.has(id) === !wasFav) {
        const rollback = new Set(favRef.current)
        if (wasFav) rollback.add(id)
        else rollback.delete(id)
        applyFavorites(rollback)
      }
      setActionError(err)
    })
  }, [enqueue])

  const watch = useCallback((item) => {
    setActionError(null)
    setPlayingId(item.id)
    const before = progressRef.current[item.id]
    const value = nextProgress(item, before)
    const next = { ...progressRef.current }
    if (value) next[item.id] = value
    else delete next[item.id]
    applyProgress(next)

    enqueue(`prog:${item.id}`, () => (value ? api.saveProgress(item.id, value) : api.markFinished(item.id))).catch((err) => {
      if (progressRef.current[item.id] === (value ?? undefined)) {
        const rollback = { ...progressRef.current }
        if (before) rollback[item.id] = before
        else delete rollback[item.id]
        applyProgress(rollback)
      }
      setActionError(err)
    })
  }, [enqueue])

  // Saves to the database first; state changes only after success. Throws on failure.
  const setGenres = useCallback(async (names) => {
    await api.saveGenres(names)
    setGenresState(names)
  }, [])

  const titlesById = useMemo(() => new Map(titles.map((t) => [t.id, t])), [titles])
  const getTitle = useCallback((id) => titlesById.get(id) ?? null, [titlesById])

  const value = useMemo(
    () => ({
      titles, genreOptions, genres, setGenres, favorites, toggleFavorite, progress, watch,
      loading, error, actionError, getTitle, openId, setOpenId, playingId, setPlayingId,
    }),
    [titles, genreOptions, genres, setGenres, favorites, toggleFavorite, progress, watch,
      loading, error, actionError, getTitle, openId, playingId],
  )
  return <MyFlixContext.Provider value={value}>{children}</MyFlixContext.Provider>
}
