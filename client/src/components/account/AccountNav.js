import React, { useState } from 'react';
import { Nav, Navbar, NavDropdown } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';

function AccountNav() {
  const [expanded, setExpanded] = useState(false);

  return (
    <>
      <Navbar bg="light" expand="lg" className="mt-3 mb-3">
        <Navbar.Brand href="#home" className="d-lg-none">
          Account Menu
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="account-nav" />
        <Navbar.Collapse>
          <Nav id="account-nav" className="flex-column">
            <NavLink to="/account/profile" activeClassName="active-profile-nav">
              Profile
            </NavLink>
            <NavLink
              to="/account/settings"
              activeClassName="active-profile-nav"
            >
              Account Settings
            </NavLink>
            <NavLink
              to="/account/involvement"
              activeClassName="active-profile-nav"
            >
              Manage my Involvement
            </NavLink>
            <NavLink to="/account/data" activeClassName="active-profile-nav">
              See my data
            </NavLink>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </>
  );
}

export default AccountNav;
