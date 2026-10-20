import { useCallback, useEffect, useMemo, useState } from 'react'
import { AuthContext } from './authContext.js'
import * as api from '../services/myflixApi.js'

// Who is logged in. On first load it recovers the session saved in the browser (so a refresh keeps
// you logged in), then follows log in / log out / session-expired events from Supabase.
export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [checking, setChecking] = useState(true)

  useEffect(() => {
    let active = true
    api
      .getCurrentUser()
      .then((u) => { if (active) setUser(u) })
      .catch(() => { if (active) setUser(null) })
      .finally(() => { if (active) setChecking(false) })
    const unsubscribe = api.onAuthChange((u) => setUser(u))
    return () => {
      active = false
      unsubscribe()
    }
  }, [])

  const signIn = useCallback(async (credentials) => {
    const session = await api.signIn(credentials)
    setUser(session.user)
  }, [])

  const signUp = useCallback(async (details) => {
    const session = await api.signUp(details)
    setUser(session.user)
  }, [])

  const signOut = useCallback(async () => {
    await api.signOut()
    setUser(null)
  }, [])

  const deleteAccount = useCallback(async () => {
    await api.deleteAccount()
    setUser(null)
  }, [])

  const value = useMemo(
    () => ({ user, checking, signIn, signUp, signOut, deleteAccount }),
    [user, checking, signIn, signUp, signOut, deleteAccount],
  )
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
