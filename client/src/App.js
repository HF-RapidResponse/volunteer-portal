import React from 'react';
import { BrowserRouter } from 'react-router-dom';

import Header from './components/Header';
import PageViewSwitch from './components/PageViewSwitch';
import Footer from './components/Footer';

import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/base.scss';
// import './styles/bootstrap-overrides.scss';

/**
 * Top level component that renders all other components.
 * Uses React Router DOM to render various pages.
 */
function App() {
  return (
    <BrowserRouter>
      <Header />
      <PageViewSwitch />
      <Footer />
    </BrowserRouter>
  );
}

export default App;
