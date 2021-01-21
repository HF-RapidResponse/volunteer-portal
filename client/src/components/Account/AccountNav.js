import React, { useState } from 'react';
import { Nav, Navbar, NavDropdown } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';

function AccountNav() {
  const [expanded, setExpanded] = useState(false);

  return (
    <>
      <Nav id="account-nav" className="flex-column mt-4 mb-4 p-3">
        <NavLink to="/account/profile" activeClassName="active-profile-nav">
          Profile
        </NavLink>
        <NavLink to="/account/settings" activeClassName="active-profile-nav">
          Account Settings
        </NavLink>
        <NavLink to="/account/involvement" activeClassName="active-profile-nav">
          Manage my Involvement
        </NavLink>
        <NavLink to="/account/data" activeClassName="active-profile-nav">
          See my data
        </NavLink>
      </Nav>
    </>
  );
}

export default AccountNav;
