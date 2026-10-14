import { useCallback, useMemo, useState } from 'react'
import { MyFlixContext } from './context.js'
import { nextProgress } from '../data/progress.js'

// All state is in-memory only: a page refresh resets it by design.
export function MyFlixProvider({ children }) {
  const [genres, setGenres] = useState([])
  const [favorites, setFavorites] = useState(() => new Set())
  const [progress, setProgress] = useState({})
  const [notes, setNotes] = useState({})
  const [openId, setOpenId] = useState(null)

  const toggleFavorite = useCallback((id) => {
    setFavorites((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }, [])

  const watch = useCallback((item) => {
    setProgress((prev) => {
      const next = { ...prev }
      const value = nextProgress(item, prev[item.id])
      if (value) next[item.id] = value
      else delete next[item.id]
      return next
    })
  }, [])

  const setNote = useCallback((id, text) => setNotes((prev) => ({ ...prev, [id]: text })), [])

  const value = useMemo(
    () => ({ genres, setGenres, favorites, toggleFavorite, progress, watch, notes, setNote, openId, setOpenId }),
    [genres, favorites, toggleFavorite, progress, watch, notes, setNote, openId],
  )
  return <MyFlixContext.Provider value={value}>{children}</MyFlixContext.Provider>
}
