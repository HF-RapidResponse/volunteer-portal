import React from 'react';
import { NavLink } from 'react-router-dom';
import { Nav, NavDropdown, Image } from 'react-bootstrap';
import { withCookies } from 'react-cookie';

import placeholderImg from '../../assets/placeholder-img.png';
import andyPic from '../../assets/andy-placeholder.jpg';

function LoggedInMenu(props) {
  const { user, profileLinks, cookies, collapse, startLogout } = props;
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
        startLogout();
        cookies.remove('user', { path: '/', sameSite: 'None', secure: true });
      }}
    >
      Log Out
    </Nav.Link>
  );
  return (
    <>
      <NavDropdown
        title={`Welcome back, ${user.first_name}!`}
        key={`nav-top-profile`}
      >
        {profileDropdown}
      </NavDropdown>
      <Image
        src={
          user.profile_pic ||
          (user.username === 'andyfromtheblock' ? andyPic : placeholderImg)
        }
        roundedCircle
        fluid
      />
    </>
  );
}

export default withCookies(LoggedInMenu);
