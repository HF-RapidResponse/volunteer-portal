import React, { useState } from 'react';
import { connect } from 'react-redux';
import useForm from './hooks/useForm';
import { Button, Form, Container, Row, Col } from 'react-bootstrap';
import { attemptLogin } from 'store/user-slice/index.js';
import { Redirect } from 'react-router-dom';

import GoogleOAuthButton from 'components/oauth/GoogleOAuthButton';
import GitHubOAuthButton from 'components/oauth/GitHubOAuthButton';
import LoadingSpinner from './LoadingSpinner';
import ForgotPasswordModal from 'components/modals/ForgotPasswordModal';

import 'styles/register-login.scss';

function Login(props) {
  const [pendingSubmit, setPendingSubmit] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const { attemptLogin, user, firstAcctPage, initLoading } = props;
  const { validated, errors, handleSubmit, handleChange, data } = useForm(
    attemptLogin
  );

  const submitWrapper = async (e) => {
    setPendingSubmit(true);
    await handleSubmit(e);
    setPendingSubmit(false);
  };

  return initLoading ? (
    <LoadingSpinner />
  ) : user && !pendingSubmit ? (
    <Redirect push to={firstAcctPage || '/account/profile'} />
  ) : (
    <>
      <h2 className="text-center">Welcome back!</h2>
      <Container className="text-center">
        <Row>
          <Col xs={12} md={6}>
            <GoogleOAuthButton />
          </Col>
          <Col xs={12} md={6}>
            <GitHubOAuthButton />
          </Col>
        </Row>
      </Container>
      <p className="horiz-line-only">or</p>
      <h3 className="text-center" style={{ color: 'gray' }}>
        Log in with e-mail
      </h3>
      <Container className="mt-4 mb-5">
        <Form noValidate validated={validated} onSubmit={submitWrapper}>
          <Form.Group controlId="formBasicEmail">
            <Form.Label>E-mail address</Form.Label>
            <Form.Control
              type="email"
              placeholder="E-mail address"
              onChange={(e) => {
                handleChange('email', e.target.value);
              }}
              required
              isInvalid={!!errors.email || !!errors.api}
            />
            <Form.Control.Feedback type="invalid">
              {!data.email ? 'Please provide an e-mail address.' : errors.email}
            </Form.Control.Feedback>
          </Form.Group>
          <Form.Group controlId="formBasicPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control
              type="password"
              placeholder="Password"
              onChange={(e) => {
                handleChange('password', e.target.value);
              }}
              required
              isInvalid={!!errors.password || !!errors.api}
            />
            <Form.Control.Feedback type="invalid">
              {!data.password
                ? 'Please provide a password.'
                : errors.password || errors.api}
            </Form.Control.Feedback>
            <div className="mt-3 mb-3">
              <p
                className="font-weight-light hover-hand-and-underline"
                style={{ color: 'gray' }}
                onClick={() => setShowModal(true)}
              >
                <u>Forgot password?</u>
              </p>
            </div>
          </Form.Group>
          <div className="text-center">
            <Button variant="info" type="submit" className="mt-5 mb-3" block>
              Login
            </Button>
          </div>
        </Form>
        <ForgotPasswordModal
          show={showModal}
          onHide={() => setShowModal(false)}
        />
      </Container>
    </>
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
    firstAcctPage: state.userStore.firstAcctPage,
    initLoading: state.userStore.initLoading,
  };
};

const mapDispatchToProps = {
  attemptLogin,
};

export default connect(mapStateToProps, mapDispatchToProps)(Login);
