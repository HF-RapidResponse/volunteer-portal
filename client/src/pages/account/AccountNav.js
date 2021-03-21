import React, { useState } from 'react';
import { Nav, Navbar, NavDropdown, Button } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faAngleLeft, faAngleRight } from '@fortawesome/free-solid-svg-icons';

function AccountNav() {
  const profileLinks = [
    { displayName: 'Profile', url: '/account/profile' },
    { displayName: 'Account Settings', url: '/account/settings' },
    { displayName: 'Manage my involvement', url: '/account/involvement' },
    { displayName: 'See my data', url: '/account/data' },
  ];

  const initialMobileLinks = profileLinks.map((linkObj, j) => {
    return (
      <NavLink
        key={'acct-nav-sm' + j}
        to={linkObj.url}
        activeClassName="active-profile-mobile"
      >
        <Button variant="info" className="btn-round ml-2 mr-2">
          {linkObj.displayName}
        </Button>
      </NavLink>
    );
  });

  const [mobileLinks, setMobileLinks] = useState(initialMobileLinks);

  const rightArrowClick = () => {
    const linksCopy = [...mobileLinks];
    linksCopy.unshift(linksCopy.pop());
    setMobileLinks(linksCopy);
  };

  const leftArrowClick = () => {
    const linksCopy = [...mobileLinks];
    linksCopy.push(linksCopy.shift());
    setMobileLinks(linksCopy);
  };

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
      <Nav
        id="account-nav-mobile"
        className="d-lg-none mt-2 mt-md-5 mb-5 text-center"
        style={{ overflow: 'hidden' }}
      >
        <FontAwesomeIcon
          icon={faAngleLeft}
          className="align-middle m-1 mb-4 mb-md-1"
          size="lg"
          style={{ fontSize: '2rem', opacity: '0.7' }}
          onClick={() => leftArrowClick()}
        />
        <div
          style={{
            overflow: 'hidden',
            whiteSpace: 'nowrap',
            display: 'inline',
          }}
        >
          {mobileLinks}
        </div>
        <FontAwesomeIcon
          icon={faAngleRight}
          size="lg"
          className="align-middle m-1 mt-4 mt-md-1"
          style={{ fontSize: '2rem', opacity: '0.7' }}
          onClick={() => rightArrowClick()}
        />
      </Nav>
    </>
  );
}

export default AccountNav;
