import { Navigate, Route, Routes } from 'react-router-dom'
import Layout from './components/Layout.jsx'
import RequireGenres from './components/RequireGenres.jsx'
import Welcome from './pages/Welcome.jsx'
import Home from './pages/Home.jsx'
import Watching from './pages/Watching.jsx'
import Favorites from './pages/Favorites.jsx'

export default function App() {
  return (
    <Routes>
      <Route path="/welcome" element={<Welcome />} />
      <Route element={<RequireGenres />}>
        <Route element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="watching" element={<Watching />} />
          <Route path="favorites" element={<Favorites />} />
        </Route>
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
