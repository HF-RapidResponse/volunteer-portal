import React from 'react';
import { BrowserRouter } from 'react-router-dom';

import Header from './components/Header';
import PageViewSwitch from './components/PageViewSwitch';

import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/base.scss';

function App() {
  return (
    <BrowserRouter>
      <Header />
      <PageViewSwitch />
    </BrowserRouter>
  );
}

export default App;
