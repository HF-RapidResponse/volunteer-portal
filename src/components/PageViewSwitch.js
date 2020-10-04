import React, { useEffect } from 'react';
import ReactGA from 'react-ga';
import { Container } from 'react-bootstrap';
import { Route, Switch, useLocation } from 'react-router-dom';

import Home from './Home';
import Calendar from './Calendar';
import Roles from './Roles';
import About from './About';

// initialize GA
// REACT_APP_GA_TRACKING_ID can be found in .env
ReactGA.initialize(process.env.REACT_APP_GA_TRACKING_ID);
function usePageViews() {
  const location = useLocation();
  useEffect(() => {
    ReactGA.pageview(`${location.pathname}${location.search}`); // Record a pageview for the given page
  }, [location]);
}

function PageViewSwitch() {
  usePageViews();
  return (
    <Container id="main-content">
      <Switch>
        <Route path="/" exact component={Home} />
        <Route path="/calendar" exact component={Calendar} />
        <Route path="/roles" exact component={Roles} />
        <Route path="/about" exact component={About} />
        {/* <Route path="/signin" exact component={Signin} /> */}
        <Route path="*" component={() => '404 NOT FOUND'} />
      </Switch>
    </Container>
  );
}

export default PageViewSwitch;
