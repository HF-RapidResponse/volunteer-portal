import React, { useState } from 'react';
import { Navbar, Nav } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import '../styles/header.scss';
import HFLogo from '../assets/HF-square-logo.svg';

/**
 * Component that displays the top navigation bar present on every page. It allows users to navigate
 * through different parts of the website. Because it is fixed,
 * the nav bar will appear even as users scroll down longer pages.
 */
function Header() {
  const links = [
    { displayName: 'Event Calendar', url: '/calendar' },
    { displayName: 'Volunteer Openings', url: '/roles' },
    { displayName: 'Register to Volunteer', url: '/volunteer' },
    { displayName: 'Our Candidates', url: '/candidates' },
    { displayName: 'About', url: '/about' },
    // { displayName: 'Sign In', url: '/signin' },
  ];

  const navLinks = [];

  const [expanded, setExpanded] = useState(false);

  for (let i = 0; i < links.length; i++) {
    const link = links[i];
    navLinks.push(
      <Link
        className="nav-link ml-3 mr-3"
        key={link.displayName + i}
        to={link.url}
        onClick={() => setTimeout(() => setExpanded(false), 100)}
      >
        {link.displayName}
      </Link>
    );
  }

  return (
    <>
      <Navbar id="main-header" fixed="top" expand="lg" expanded={expanded}>
        <Link
          className="nav-link"
          key="home-key"
          to="/"
          onClick={() => setTimeout(() => setExpanded(false), 100)}
        >
          <img src={HFLogo} alt="HF Logo" id="hf-logo" />
        </Link>
        <Navbar.Toggle
          aria-controls="basic-navbar-nav"
          onClick={() => setExpanded(!expanded)}
        />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="ml-auto" id="links-container">
            <>{navLinks}</>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </>
  );
}

export default Header;
