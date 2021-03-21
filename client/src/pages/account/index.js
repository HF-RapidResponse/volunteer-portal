import React from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Container, Col, Row, Image } from 'react-bootstrap';

import AccountNav from './AccountNav';
import Profile from './Profile';
import Involvement from './Involvement';
import Settings from './Settings';
import Data from './Data';
import { attemptLogin, startLogout } from 'store/user-slice/index.js';
import './index.scss';

import placeholderImg from 'assets/placeholder-img.png';
import andyPic from 'assets/andy-placeholder.jpg';

function AccountIndex(props) {
  const { user } = props;
  const path = window.location.pathname;

  let mainContent;
  /* eslint-disable indent */
  switch (path) {
    case '/account/profile':
      mainContent = <Profile />;
      break;
    case '/account/settings':
      mainContent = <Settings />;
      break;
    case '/account/involvement':
      mainContent = <Involvement />;
      break;
    case '/account/data':
      mainContent = <Data />;
      break;
    default:
      break;
  }
  /* eslint-enable indent */

  return user && mainContent ? (
    <>
      <Container className="mt-1 mb-4">
        <Row className="text-center md-text-left">
          <Col xs={12} md={2}>
            <Image
              src={
                user.profile_pic ||
                (user.username === 'andyfromtheblock'
                  ? andyPic
                  : placeholderImg)
              }
              roundedCircle
              fluid
              style={{ maxWidth: '80px' }}
            />
          </Col>
          <Col xs={12} md={10} xl={5} className="mt-3 mb-3 align-self-center">
            <h2>{user.username} / Account</h2>
          </Col>
        </Row>
        <Row className="mt-2 mb-2 mt-lg-5 mb-lg-5">
          <Col xs={12} lg={4}>
            <AccountNav />
          </Col>
          <Col xs={12} lg={7} className="ml-lg-5">
            {mainContent}
          </Col>
        </Row>
      </Container>
    </>
  ) : mainContent ? (
    <Redirect push to="/login" />
  ) : (
    <Redirect push to="/error" />
  );
}

const mapStateToProps = (state, ownProps) => {
  return {
    user: state.userStore.user,
    cookies: ownProps.cookies,
  };
};
const mapDispatchToProps = { attemptLogin, startLogout };

export default connect(mapStateToProps, mapDispatchToProps)(AccountIndex);
