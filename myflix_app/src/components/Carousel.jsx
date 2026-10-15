import { useCallback, useEffect, useRef, useState } from 'react'
import Card from './Card.jsx'

export default function Carousel({ id, title, items, empty }) {
  const track = useRef(null)
  const [edges, setEdges] = useState({ start: true, end: true })

  const measure = useCallback(() => {
    const el = track.current
    if (!el) return
    setEdges({
      start: el.scrollLeft <= 1,
      end: el.scrollLeft + el.clientWidth >= el.scrollWidth - 1,
    })
  }, [])

  useEffect(() => {
    measure()
    window.addEventListener('resize', measure)
    return () => window.removeEventListener('resize', measure)
  }, [measure, items.length])

  function page(dir) {
    const el = track.current
    const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches
    el.scrollBy({ left: dir * el.clientWidth * 0.9, behavior: reduce ? 'auto' : 'smooth' })
  }

  return (
    <section className="shelf" aria-labelledby={`${id}-h`}>
      <h2 id={`${id}-h`} className="shelf-title">{title}</h2>
      {items.length === 0 ? (
        <p className="shelf-empty">{empty}</p>
      ) : (
        <div className="shelf-row">
          <button type="button" className="arrow" aria-label={`Scroll ${title} left`} disabled={edges.start} onClick={() => page(-1)}>
            <svg viewBox="0 0 24 24" width="24" height="24" aria-hidden="true"><path d="M15 5l-7 7 7 7" /></svg>
          </button>
          <div className="track" ref={track} onScroll={measure} role="list">
            {items.map((item) => (
              <div className="slot" role="listitem" key={item.id}><Card item={item} /></div>
            ))}
          </div>
          <button type="button" className="arrow" aria-label={`Scroll ${title} right`} disabled={edges.end} onClick={() => page(1)}>
            <svg viewBox="0 0 24 24" width="24" height="24" aria-hidden="true"><path d="M9 5l7 7-7 7" /></svg>
          </button>
        </div>
      )}
    </section>
  )
}
