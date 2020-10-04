import React from 'react';
import { Container } from 'react-bootstrap';
import { BrowserRouter } from 'react-router-dom';

import Header from './components/Header';
import PageViewSwitch from './components/PageViewSwitch';
// import Signin from './components/Signin';

import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/base.scss';

function App() {
  return (
    <BrowserRouter>
      <Header />
      <Container id="main-content">
        <PageViewSwitch />
      </Container>
    </BrowserRouter>
  );
}

export default App;
