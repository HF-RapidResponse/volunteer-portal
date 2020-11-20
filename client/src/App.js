import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';

import Header from './components/Header';
import PageViewSwitch from './components/PageViewSwitch';
import Footer from './components/Footer';
import store from './store';

import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/base.scss';

/**
 * Top level component that renders all other components.
 * Uses React Router DOM to render various pages.
 */
function App() {
  return (
    <Provider store={store}>
      <BrowserRouter>
        <Header />
        <PageViewSwitch />
        <Footer />
      </BrowserRouter>
    </Provider>
  );
}

export default App;
