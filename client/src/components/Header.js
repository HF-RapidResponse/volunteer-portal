import React, { useState, useEffect } from 'react';
import { connect } from 'react-redux';
import { Navbar, Nav, NavDropdown, Button, Image } from 'react-bootstrap';
import { Link, NavLink } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import '../styles/header.scss';
import HFLogo from '../assets/HF-RR-long-logo.png';
import placeholderImg from '../assets/andy-placeholder.jpg';
import {
  attemptLogin,
  startLogout,
  loadLoggedInUser,
  setFirstAcctPage,
} from '../store/user-slice.js';

/**
 * Component that displays the top navigation bar present on every page. It allows users to navigate
 * through different parts of the website. Because it is fixed,
 * the nav bar will appear even as users scroll down longer pages.
 */

function Header(props) {
  const [expanded, setExpanded] = useState(false);
  const [initiatives, setInitiatives] = useState([]);
  // const [currPath, setCurrPath] = useState(window.location.pathname);
  const {
    startLogout,
    user,
    firstAcctPage,
    cookies,
    loadLoggedInUser,
    setFirstAcctPage,
  } = props;

  const firstPath = window.location.pathname;
  // console.log('What is firstPath?', firstPath, firstAcctPage);

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
    fetch('/api/initiatives')
      .then((response) => {
        if (response.ok) {
          response.json().then((data) => {
            setInitiatives(data);
          });
        } else {
          console.error(response);
        }
      })
      .catch((err) => {
        console.error(err);
      });
  }, []);

  useEffect(() => {
    // console.log('inside the user useEffect?', user);
    if (user) {
      cookies.set('user', user, { path: '/' });
    }
  }, [user]);

  const links = [
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
    // { displayName: 'About Us', url: '/about' },
    // { displayName: 'Our Candidates', url: '/candidates' },
    // { displayName: 'Sign In', url: '/signin' },
  ];

  const navLinks = [];

  function collapse() {
    setTimeout(() => setExpanded(false), 100);
  }

  for (let i = 0; i < links.length; i++) {
    const link = links[i];
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
          to={`/initiatives/`}
          key={`nav-dropdown-child-${link.children.length + 1}`}
          onClick={collapse}
        >
          See All Initiatives
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

  const profileLinks = [
    { displayName: 'My profile', url: '/account/profile' },
    { displayName: 'Account Settings', url: '/account/settings' },
    { displayName: 'Manage my involvement', url: '/account/involvement' },
    { displayName: 'See my data', url: '/account/data' },
  ];

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
          <img src={HFLogo} alt="HF Logo" id="hf-logo" />
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
              <>
                <NavDropdown
                  title={`Welcome back, ${user.username}!`}
                  key={`nav-top-profile`}
                >
                  {profileDropdown}
                </NavDropdown>
                <Image src={placeholderImg} roundedCircle fluid />
              </>
            ) : (
              <>
                <Link to={'/register'} className="mt-1 mb-1">
                  <Button
                    variant="info"
                    className="wide-btn ml-3 mr-3"
                    style={{ padding: '.4rem 1.8rem' }}
                    onClick={collapse}
                  >
                    Create an Account
                  </Button>
                </Link>
                <Link to={'/login'} className="mt-1 mb-1">
                  <Button
                    variant="outline-info"
                    className="wide-btn ml-3 mr-3"
                    style={{ padding: '.4rem 1.8rem' }}
                  >
                    Log In
                  </Button>
                </Link>
              </>
            )}
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </>
  );
}

const mapStateToProps = (state, ownProps) => {
  return {
    user: state.userStore.user,
    cookies: ownProps.cookies,
    firstAcctPage: state.userStore.firstAcctPage,
  };
};

const mapDispatchToProps = {
  attemptLogin,
  startLogout,
  loadLoggedInUser,
  setFirstAcctPage,
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(Header)
);
