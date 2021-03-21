import React, { useEffect } from 'react';
import ReactGA from 'react-ga';
import { Container } from 'react-bootstrap';
import { Route, Switch, useLocation, withRouter } from 'react-router-dom';

import Home from './Home';
import Calendar from './Calendar';
import Roles from './Roles';
import Candidates from './Candidates';
import Register from './Register';
import Initiatives from 'pages/initiatives';
import Initiative from 'pages/initiatives/initiative';
import Account from 'pages/account';
import NotFound from './NotFound';
import Login from './Login';
import LoginCallback from './LoginCallback';
import Dashboard from './Dashboard';

// initialize GA
// REACT_APP_GA_TRACKING_ID can be found in .env
ReactGA.initialize(process.env.REACT_APP_GA_TRACKING_ID);
function usePageViews() {
  const location = useLocation();
  useEffect(() => {
    ReactGA.pageview(`${location.pathname}${location.search}`); // Record a pageview for the given page
    window.scrollTo(0, 0);
  }, [location]);
}

/**
 * Component that helps gather Google Analytics
 * It runs a helper function that records information before rendering the appropriate page.
 */
function PageViewSwitch() {
  usePageViews();
  return (
    <Container id="main-content">
      <Switch>
        <Route path="/" exact component={Home} />
        <Route path="/calendar" exact component={Calendar} />
        <Route path="/roles" exact component={Roles} />
        <Route path="/candidates" exact component={Candidates} />
        <Route path="/register" exact component={Register} />
        <Route path="/initiatives" exact component={Initiatives} />
        <Route
          path="/initiatives/:ext_id"
          exact
          component={withRouter(Initiative)}
        />
        <Route path="/login" exact component={Login} />
        <Route path="/login_callback" exact component={LoginCallback} />
        <Route path="/dashboard" exact component={Dashboard} />
        <Route path="/account/*" component={Account} />
        <Route path="*" component={NotFound} />
      </Switch>
    </Container>
  );
}

export default PageViewSwitch;
