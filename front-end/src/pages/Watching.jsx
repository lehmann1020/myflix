import CardGrid from '../components/CardGrid.jsx'
import { useMyFlix } from '../state/useMyFlix.js'

export default function Watching() {
  const { titles, progress } = useMyFlix()
  const items = titles.filter((c) => progress[c.id])
  return <CardGrid title="Currently Watching" items={items} empty="Nothing in progress. Add where you left off on any title and it shows up here." />
}
