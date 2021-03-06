import React, { useState, useEffect } from 'react';
import { connect } from 'react-redux';
import { Navbar, Nav, Image } from 'react-bootstrap';
import { NavLink, withRouter } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import '../../styles/header.scss';
import HFLogo from '../../assets/HF-RR-long-logo.png';
import {
  attemptLogin,
  startLogout,
  loadLoggedInUser,
  setFirstAcctPage,
  syncInitMapAndLoadUser,
  checkIfCookieIsValid,
} from '../../store/user-slice/index.js';
import { getInitiatives } from '../../store/initiative-slice';

import LoggedInMenu from './LoggedInMenu';
import LoggedOutMenu from './LoggedOutMenu';
import MainMenu from './MainMenu';

/**
 * Component that displays the top navigation bar present on every page. It allows users to navigate
 * through different parts of the website. Because it is fixed,
 * the nav bar will appear even as users scroll down longer pages.
 */
function Header(props) {
  const [expanded, setExpanded] = useState(false);
  const [blueBarTitle, setBlueBarTitle] = useState();
  const {
    startLogout,
    user,
    firstAcctPage,
    cookies,
    loadLoggedInUser,
    setFirstAcctPage,
    history,
    initiatives,
    getInitiatives,
    syncInitMapAndLoadUser,
    checkIfCookieIsValid,
  } = props;

  const firstPath = window.location.pathname;
  const params = new URLSearchParams(window.location.search);

  const mainLinks = [
    {
      displayName: 'Our Initiatives',
      url: '/initiatives',
      children: initiatives,
    },
    { displayName: 'Event Calendar', url: '/calendar' },
    { displayName: 'Volunteer Roles', url: '/roles' },
    {
      displayName: 'Return to Parent Site',
      url: 'https://movehumanityforward.com/',
    },
  ];

  const acctLinks = [
    { displayName: 'Create an Account', url: '/register' },
    { displayName: 'Log In', url: '/login' },
  ];

  const profileLinks = [
    { displayName: 'My profile', url: '/account/profile' },
    { displayName: 'Account Settings', url: '/account/settings' },
    { displayName: 'Manage my involvement', url: '/account/involvement' },
    { displayName: 'See my data', url: '/account/data' },
  ];

  useEffect(() => {
    getInitiatives();
    const userID = params.get('user_id');
    if (userID) {
      syncInitMapAndLoadUser(userID);
    } else if (user) {
      loadLoggedInUser(user);
    } else {
      const cookieID = cookies.get('user_id');
      if (cookieID) {
        checkIfCookieIsValid(cookies);
        if (firstPath.includes('/account') && !firstAcctPage) {
          setFirstAcctPage(firstPath);
        }
        syncInitMapAndLoadUser(cookieID);
      }
    }
  }, []);

  useEffect(() => {
    if (user) {
      cookies.set('user_id', user.uuid, {
        path: '/',
        sameSite: 'none',
        secure: true,
      });
    }
  }, [user]);

  function collapse() {
    setTimeout(() => setExpanded(false), 100);
  }

  useEffect(() => {
    const currPath = history.location.pathname;
    const matchingLink =
      mainLinks.find((item) => item.url === currPath) ||
      acctLinks.find((item) => item.url === currPath);
    setBlueBarTitle(matchingLink ? matchingLink.displayName : null);
  }, [history.location.pathname]);

  return (
    <>
      <Navbar
        id="main-header"
        className="pt-3 pb-3"
        fixed="top"
        expand="xxl"
        expanded={expanded}
      >
        <NavLink className="nav-link" key="home-key" to="/" onClick={collapse}>
          <Image src={HFLogo} alt="HF Logo" id="hf-logo" fluid />
        </NavLink>
        <Navbar.Toggle
          aria-controls="main-nav"
          onClick={() => setExpanded(!expanded)}
        />
        <Navbar.Collapse id="main-nav">
          <MainMenu mainLinks={mainLinks} collapse={collapse} />
          <Nav className="account-container">
            {user ? (
              <LoggedInMenu
                user={user}
                profileLinks={profileLinks}
                collapse={collapse}
                startLogout={startLogout}
              />
            ) : (
              <LoggedOutMenu acctLinks={acctLinks} collapse={collapse} />
            )}
          </Nav>
        </Navbar.Collapse>
      </Navbar>
      {blueBarTitle ? (
        <div id="title-header">
          <h1>{blueBarTitle}</h1>
        </div>
      ) : (
        <div className="no-blue-bar"></div>
      )}
    </>
  );
}

const mapStateToProps = (state, ownProps) => {
  return {
    user: state.userStore.user,
    cookies: ownProps.cookies,
    firstAcctPage: state.userStore.firstAcctPage,
    initiatives: state.initiativeStore.initiatives,
  };
};

const mapDispatchToProps = {
  attemptLogin,
  startLogout,
  loadLoggedInUser,
  setFirstAcctPage,
  getInitiatives,
  syncInitMapAndLoadUser,
  checkIfCookieIsValid,
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(withRouter(Header))
);
