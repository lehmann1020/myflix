import { Link } from 'react-router-dom'
import Card from './Card.jsx'

export default function CardGrid({ title, items, empty }) {
  return (
    <section className="page">
      <h1 className="grid-title">{title}</h1>
      {items.length === 0 ? (
        <div className="shelf-empty">
          <p>{empty}</p>
          <Link to="/browse" className="btn-primary link-btn">Browse titles</Link>
        </div>
      ) : (
        <div className="card-grid">
          {items.map((item) => <Card key={item.id} item={item} />)}
        </div>
      )}
    </section>
  )
}
