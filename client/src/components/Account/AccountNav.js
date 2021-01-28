import React, { useState } from 'react';
import { Nav, Navbar, NavDropdown, Button } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';

function AccountNav() {
  const profileLinks = [
    { displayName: 'Profile', url: '/account/profile' },
    { displayName: 'Account Settings', url: '/account/settings' },
    { displayName: 'Manage my involvement', url: '/account/involvement' },
    { displayName: 'See my data', url: '/account/data' },
  ];

  return (
    <>
      <Nav
        id="account-nav"
        className="flex-column mt-4 mb-4 p-3 d-none d-lg-flex"
      >
        {profileLinks.map((linkObj, i) => {
          return (
            <NavLink
              key={'acct-nav-lg' + i}
              to={linkObj.url}
              activeClassName="active-profile-nav"
            >
              {linkObj.displayName}
            </NavLink>
          );
        })}
      </Nav>
      <Nav id="account-nav-mobile" className="d-flex d-lg-none">
        {profileLinks.map((linkObj, j) => {
          return (
            <Button
              variant="info"
              className="btn-round m-2"
              key={'acct-nav-sm' + j}
            >
              {linkObj.displayName}
            </Button>
          );
        })}
      </Nav>
    </>
  );
}

export default AccountNav;
