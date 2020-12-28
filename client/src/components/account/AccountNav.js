import React from 'react';
import { Nav } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';

function AccountNav() {
  return (
    <Nav defaultActiveKey="/home" className="flex-column" id="account-nav">
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
  );
}

export default AccountNav;
