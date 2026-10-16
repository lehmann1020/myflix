import { useMemo } from 'react'
import { CATALOG } from '../data/catalog.js'
import Carousel from '../components/Carousel.jsx'
import { useMyFlix } from '../state/useMyFlix.js'

export default function Home() {
  const { genres, progress } = useMyFlix()

  const picks = useMemo(() => {
    const score = (c) => c.genres.filter((g) => genres.includes(g)).length
    return CATALOG.filter((c) => score(c) > 0).sort((a, b) => score(b) - score(a))
  }, [genres])

  const watching = CATALOG.filter((c) => progress[c.id])

  return (
    <div className="page home">
      <Carousel id="picks" title="I think you'd like" items={picks} empty="No matches yet." />
      <Carousel
        id="continue"
        title="Continue watching"
        items={watching}
        empty="Nothing in progress. Add where you left off on any title and it shows up here."
      />
    </div>
  )
}
