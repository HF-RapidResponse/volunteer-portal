import React from 'react';
import { connect } from 'react-redux';
import { Navbar, Nav, NavDropdown, Button, Image } from 'react-bootstrap';
import { Link } from 'react-router-dom';

function AccountNav(props) {
  const { user } = props;
  const path = window.location.pathname;
  console.log(
    'What is window.location.pathname in account nav?',
    window.location.pathname
  );
  return (
    <Nav defaultActiveKey="/home" className="flex-column">
      <Link
        to="/account/profile"
        active={path === '/account/profile' ? 'active' : null}
      >
        Profile
      </Link>
      <Link to="/account/settings" className={window}>
        Account Settings
      </Link>
      <Link to="/account/involvement">Manage my Involvement</Link>
      <Link to="/account/data">See my data</Link>
    </Nav>
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

export default connect(mapStateToProps)(AccountNav);
