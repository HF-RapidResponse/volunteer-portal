import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import { withCookies } from 'react-cookie';

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
function App(props) {
  const { cookies } = props;
  console.log('do we have cookies?', cookies);
  return (
    <Provider store={store}>
      <BrowserRouter>
        <Header cookies={cookies} />
        <PageViewSwitch />
        <Footer />
      </BrowserRouter>
    </Provider>
  );
}

export default withCookies(App);
