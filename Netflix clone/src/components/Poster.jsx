import { useState } from 'react'

// Photo poster with a generated gradient behind it as a fallback if the image fails to load.
export default function Poster({ id, title, hue }) {
  const [failed, setFailed] = useState(false)
  const initials = title.split(/\s+/).filter((w) => w.length > 2).slice(0, 2).map((w) => w[0]).join('').toUpperCase()
  return (
    <div className="poster" style={{ '--h': hue }} aria-hidden="true">
      {failed ? (
        <span className="poster-initials">{initials || title[0]}</span>
      ) : (
        <img src={`/posters/${id}.jpg`} alt="" loading="lazy" draggable="false" onError={() => setFailed(true)} />
      )}
    </div>
  )
}
