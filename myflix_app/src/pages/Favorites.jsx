import { CATALOG } from '../data/catalog.js'
import CardGrid from '../components/CardGrid.jsx'
import { useMyFlix } from '../state/useMyFlix.js'

export default function Favorites() {
  const { favorites } = useMyFlix()
  const items = CATALOG.filter((c) => favorites.has(c.id))
  return <CardGrid title="Favorites" items={items} empty="No favorites yet. Tap the star on any title." />
}
