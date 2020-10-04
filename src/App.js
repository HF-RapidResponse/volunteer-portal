import React from 'react';
import ReactGA from 'react-ga';
import Header from './components/Header';
import Home from './components/Home';
import Calendar from './components/Calendar';
import Roles from './components/Roles';
import About from './components/About';
// import Signin from './components/Signin';

import { Container } from 'react-bootstrap';
import { BrowserRouter, Route, Switch, useLocation } from 'react-router-dom';
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

// initialize GA
// REACT_APP_GA_TRACKING_ID can be found in .env
ReactGA.initialize(process.env.REACT_APP_GA_TRACKING_ID);
function usePageViews() {
  let location = useLocation();
  React.useEffect(() => {
    ReactGA.pageview(`${location.pathname}${location.search}`); // Record a pageview for the given page
  }, [location]);
}

function PageViewSwitch() {
  usePageViews();
  return (
    <Switch>
      <Route path="/" exact component={Home} />
      <Route path="/calendar" exact component={Calendar} />
      <Route path="/roles" exact component={Roles} />
      <Route path="/about" exact component={About} />
      {/* <Route path="/signin" exact component={Signin} /> */}
      <Route path="*" component={() => '404 NOT FOUND'} />
    </Switch>
  );
}

export default App;
