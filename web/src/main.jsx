import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import {BrowserRouter} from 'react-router-dom'
import App from './App.jsx'
import Styles from './components/Styles.jsx'


createRoot(document.getElementById('root')).render(
  <BrowserRouter>
  <Styles>
    <App/>
  </Styles>
  </BrowserRouter>
)
