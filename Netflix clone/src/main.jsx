import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import './index.css'
import App from './App.jsx'
import { MyFlixProvider } from './state/MyFlixContext.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <MyFlixProvider>
        <App />
      </MyFlixProvider>
    </BrowserRouter>
  </StrictMode>,
)
