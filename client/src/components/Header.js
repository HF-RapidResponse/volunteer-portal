import React, { useState, useEffect } from 'react';
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
  const [expanded, setExpanded] = useState(false);
  const [initiatives, setInitiatives] = useState([]);
  const [fetched, setFetched] = useState(false);

  useEffect(() => {
    fetch('/api/initiatives')
      .then((response) => {
        if (response.ok) {
          response.json().then((data) => {
            setInitiatives(data);
          });
        } else {
          console.error(response);
        }
        setFetched(true);
      })
      .catch((err) => {
        console.error(err);
        setFetched(true);
      });
  }, []);

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
          <Link
            className="nav-link ml-5 mr-5"
            to={`/initiatives/${child.initiative_external_id}`}
            key={`nav-dropdown-child-${j}`}
            onClick={collapse}
          >
            {child.name}
          </Link>
        );
      }
      dropdownItems.push(
        <>
          <NavDropdown.Divider />
          <Link
            className="nav-link ml-5 mr-5"
            to={`/initiatives/`}
            key={`nav-dropdown-child-${link.children.length}`}
            onClick={collapse}
          >
            See All Initiatives
          </Link>
        </>
      );
      navLinks.push(
        <NavDropdown title={link.displayName} key={`nav-top-item-${i}`}>
          {dropdownItems}
        </NavDropdown>
      );
    } else {
      navLinks.push(
        link && link.url[0] === '/' ? (
          <Link
            className="nav-link ml-3 mr-3 text-center"
            key={`nav-top-item-${i}`}
            to={link.url}
            onClick={collapse}
          >
            {link.displayName}
          </Link>
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

  return (
    <>
      <Navbar
        id="main-header"
        className="pt-3 pb-3"
        fixed="top"
        expand="xl"
        expanded={expanded}
      >
        <Link className="nav-link" key="home-key" to="/" onClick={collapse}>
          <img src={HFLogo} alt="HF Logo" id="hf-logo" />
        </Link>
        <Navbar.Toggle
          aria-controls="basic-navbar-nav"
          onClick={() => setExpanded(!expanded)}
        />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="d-lg-flex align-items-center mr-auto">
            <>{navLinks}</>
          </Nav>
          <Nav className="text-center">
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
                Login
              </Button>
            </Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </>
  );
}

export default Header;
