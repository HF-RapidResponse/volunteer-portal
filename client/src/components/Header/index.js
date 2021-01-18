import React, { useState, useEffect } from 'react';
import { connect } from 'react-redux';
import { Navbar, Nav, NavDropdown, Button, Image } from 'react-bootstrap';
import { Link, NavLink, withRouter } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import '../../styles/header.scss';
import HFLogo from '../../assets/HF-RR-long-logo.png';
import {
  attemptLogin,
  startLogout,
  loadLoggedInUser,
  setFirstAcctPage,
} from '../../store/user-slice.js';
import { getInitiatives } from '../../store/initiative-slice';

import LoggedInMenu from './LoggedInMenu';
import LoggedOutMenu from './LoggedOutMenu';

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
  } = props;

  const firstPath = window.location.pathname;

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
    if (!user) {
      const userCookie = cookies.get('user');
      if (userCookie) {
        if (firstPath.includes('/account') && !firstAcctPage) {
          setFirstAcctPage(firstPath);
        }
        loadLoggedInUser(userCookie);
      }
    }
    getInitiatives();
  }, []);

  useEffect(() => {
    if (user) {
      cookies.set('user', user, { path: '/' });
    }
  }, [user]);

  function collapse() {
    setTimeout(() => setExpanded(false), 100);
  }

  const navLinks = [];

  for (let i = 0; i < mainLinks.length; i++) {
    const link = mainLinks[i];
    if (link.children && link.children.length) {
      const dropdownItems = [];
      for (let j = 0; j < link.children.length; j++) {
        const child = link.children[j];
        dropdownItems.push(
          <NavLink
            className="nav-link ml-5 mr-5"
            to={`/initiatives/${child.initiative_external_id}`}
            key={`nav-dropdown-child-${j}`}
            onClick={collapse}
          >
            {child.name}
          </NavLink>
        );
      }
      dropdownItems.push(
        <NavDropdown.Divider
          key={`nav-dropdown-child-${link.children.length}`}
        />
      );
      dropdownItems.push(
        <NavLink
          className="nav-link ml-5 mr-5"
          to={`${link.url}`}
          key={`nav-dropdown-child-${link.children.length + 1}`}
          onClick={collapse}
        >
          {`See All ${link.displayName.split(' ')[1] || link.displayName}`}
        </NavLink>
      );
      navLinks.push(
        <NavDropdown title={link.displayName} key={`nav-top-item-${i}`}>
          {dropdownItems}
        </NavDropdown>
      );
    } else {
      navLinks.push(
        link && link.url[0] === '/' ? (
          <NavLink
            className="nav-link ml-3 mr-3 text-center"
            key={`nav-top-item-${i}`}
            to={link.url}
            onClick={collapse}
          >
            {link.displayName}
          </NavLink>
        ) : (
          <a
            className="nav-link ml-3 mr-3 text-center"
            href={link.url}
            key={`nav-top-item-${i}`}
            onClick={collapse}
          >
            {link.displayName}
          </a>
        )
      );
    }
  }

  useEffect(() => {
    const currPath = history.location.pathname;
    const matchingLink =
      mainLinks.find((item) => item.url === currPath) ||
      acctLinks.find((item) => item.url === currPath);
    setBlueBarTitle(matchingLink ? matchingLink.displayName : null);
  }, [history.location.pathname]);
  const profileDropdown = [];

  for (let i = 0; i < profileLinks.length; i++) {
    const link = profileLinks[i];
    profileDropdown.push(
      <NavLink
        className="nav-link ml-3 mr-3"
        key={`nav-profile-dropdown-${i}`}
        to={link.url}
        onClick={collapse}
      >
        {link.displayName}
      </NavLink>
    );
  }

  profileDropdown.push(
    <NavDropdown.Divider key={`nav-profile-dropdown-${profileLinks.length}`} />
  );
  profileDropdown.push(
    <Nav.Link
      className="nav-link ml-3 mr-3"
      key={`nav-profile-dropdown-${profileLinks.length + 1}`}
      onClick={() => {
        cookies.remove('user', { path: '/' });
        startLogout();
      }}
    >
      Log Out
    </Nav.Link>
  );
  return (
    <>
      <Navbar
        id="main-header"
        className="pt-3 pb-3"
        fixed="top"
        expand="xl"
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
          <Nav className="d-lg-flex align-items-center mr-auto">
            <>{navLinks}</>
          </Nav>
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
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(withRouter(Header))
);
