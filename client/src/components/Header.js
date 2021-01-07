import React, { useState } from 'react';
import { Navbar, Nav, NavDropdown, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import '../styles/header.scss';
import HFLogo from '../assets/HF-RR-long-logo.png';

/**
 * Component that displays the top navigation bar present on every page. It allows users to navigate
 * through different parts of the website. Because it is fixed,
 * the nav bar will appear even as users scroll down longer pages.
 */

function Header() {
  const links = [
    { displayName: 'Our Initiatives', url: '/initiatives' },
    { displayName: 'Event Calendar', url: '/calendar' },
    { displayName: 'Volunteer Roles', url: '/roles' },
    // { displayName: 'About Us', url: '/about' },
    // { displayName: 'Our Candidates', url: '/candidates' },
    // { displayName: 'Sign In', url: '/signin' },
  ];

  const navLinks = [];

  const [expanded, setExpanded] = useState(false);

  function collapse() { setTimeout(() => setExpanded(false), 100); }

  for (let i = 0; i < links.length; i++) {
    const link = links[i];
    if (link.children) {
      const dropdownItems = [];
      for (let j = 0; j < link.children.length; j++) {
        const child = link.children[j];
        dropdownItems.push(
          <Link
            className="nav-link ml-5 mr-5"
            to={child.url}
            key={`nav-child-${j}`}
            onClick={collapse}
          >
            {child.displayName}
          </Link>
        );
      }
      navLinks.push(
        <NavDropdown title={link.displayName} key={`nav-dropdown-${i}`}>
          {dropdownItems}
        </NavDropdown>
      );
    } else {
      navLinks.push(
        link && link[0] === '/' ? (
          <Link
            className="nav-link ml-3 mr-3 text-center"
            key={link.displayName + i}
            to={link.url}
            onClick={collapse}
          >
            {link.displayName}
          </Link>
        ) : (
          <a
            className="nav-link ml-3 mr-3 text-center"
            href={link.url}
            key={`nav-child-${i}`}
            onClick={collapse}
          >
            {link.displayName}
          </a>
        )
      );
    }
  }

  return (
    <>
      <Navbar
        id="main-header"
        className="pt-4 pb-4"
        fixed="top"
        expand="xl"
        expanded={expanded}
      >
        <Link
          className="nav-link"
          key="home-key"
          to="/"
          onClick={collapse}
        >
          <img src={HFLogo} alt="HF Logo" id="hf-logo" />
        </Link>
        <Navbar.Toggle
          aria-controls="basic-navbar-nav"
          onClick={() => setExpanded(!expanded)}
        />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav
            className="ml-auto d-lg-flex align-items-center"
            id="links-container"
          >
            <>{navLinks}</>
            <Link to={'/register'}>
              <Button
                variant="info"
                className="wide-btn"
                style={{ padding: '.4rem 2.25rem' }}
                onClick={collapse}
              >
                Register to Volunteer
              </Button>
            </Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </>
  );
}

export default Header;
