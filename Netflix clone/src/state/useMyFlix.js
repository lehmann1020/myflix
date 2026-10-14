import { useContext } from 'react'
import { MyFlixContext } from './context.js'

export function useMyFlix() {
  const ctx = useContext(MyFlixContext)
  if (!ctx) throw new Error('useMyFlix must be used inside MyFlixProvider')
  return ctx
}
