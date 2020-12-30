import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';

import AccountNav from './AccountNav';
import placeholderImg from '../../assets/andy-placeholder.jpg';
import Profile from './Profile';
import Involvement from './Involvement';
import Settings from './Settings';
import Data from './Data';

import '../../styles/account.scss';

function AccountIndex(props) {
  const { user } = props;
  let mainContent;

  /* eslint-disable indent */
  switch (window.location.pathname) {
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
      <Container>
        <Row className="text-center md-text-left">
          <Col xs={12} md={2}>
            <Image
              src={placeholderImg}
              roundedCircle
              fluid
              style={{ maxWidth: '80px' }}
            />
          </Col>
          <Col xs={12} md={10} xl={5} className="align-self-center">
            <h2>{user.username} / Account</h2>
          </Col>
        </Row>
        <Row className="mt-lg-5 mb-lg-5">
          <Col xs={12} lg={4} className="mt-5">
            <AccountNav />
          </Col>
          <Col xs={12} lg={6}>
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

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

export default connect(mapStateToProps)(AccountIndex);
