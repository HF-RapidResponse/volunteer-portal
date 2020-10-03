import React from 'react';
import Header from './components/Header';
import Home from './components/Home';
import Calendar from './components/Calendar';
import Roles from './components/Roles';
import About from './components/About';
import Signin from './components/Signin';

import { Container } from 'react-bootstrap';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/base.scss';

function App() {
  return (
    <BrowserRouter>
      <Header />
      <Container id="main-content">
        <Switch>
          <Route path="/" exact component={Home} />
          <Route path="/calendar" exact component={Calendar} />
          <Route path="/roles" exact component={Roles} />
          <Route path="/about" exact component={About} />
          <Route path="/signin" exact component={Signin} />
        </Switch>
      </Container>
    </BrowserRouter>
  );
}

export default App;
