import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';
import AccountNav from './AccountNav';
import placeholderImg from '../../assets/andy-placeholder.jpg';
import Profile from './Profile';

function AccountIndex(props) {
  const { user } = props;
  let mainContent;
  console.log('What is pathname?', window.location.pathname);
  /* eslint-disable indent */
  switch (window.location.pathname) {
    case '/account/profile':
      mainContent = <Profile />;
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
          <Col xs={12} md={5} className="align-self-center">
            <h2>{user.username} / Account</h2>
          </Col>
        </Row>
        <Row className="mt-5 mb-5">
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
