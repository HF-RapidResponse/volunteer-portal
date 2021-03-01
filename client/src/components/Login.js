import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import useForm from './hooks/useForm';
import { Button, Form, Container, Image, Row, Col } from 'react-bootstrap';
import {
  attemptLogin,
  validateEmail,
  openGoogleOauthWindow,
} from '../store/user-slice.js';
import { Redirect } from 'react-router-dom';
import { Link } from 'react-router-dom';
import GoogleOAuthButton from './OAuth/GoogleOAuthButton';
import LoadingSpinner from './LoadingSpinner';

function Login(props) {
  const [submitted, setSubmitted] = useState(false);
  const [validated, setValidated] = useState(false);
  const [loading, setLoading] = useState(false);
  const {
    attemptLogin,
    user,
    firstAcctPage,
    validateEmail,
    openGoogleOauthWindow,
  } = props;
  const { handleSubmit, handleChange, data } = useForm(attemptLogin);
  const path = window.location.pathname;
  const params = new URLSearchParams(window.location.search);

  /**
   * simple helper function that handles form submission by calling several other functions
   * @param {*} e - event object
   */
  function submitWrapper(e) {
    setSubmitted(handleSubmit(e));
    setValidated(true);
  }

  /**
   * simple helper function that checks for enter key to do for submission
   * @param {Object} e - event object
   */
  function handleKeyPress(key, e) {
    if (e.key === 'Enter') {
      submitWrapper(e);
    } else {
      handleChange(key, e.target.value);
    }
  }

  useEffect(() => {
    const userID = params.get('user_id');
    if (userID) {
      setLoading(true);
    }
  }, [params]);

  useEffect(() => {
    if (user) {
      setLoading(false);
    }
  }, [user]);

  return loading ? (
    <LoadingSpinner />
  ) : (validated && submitted) || user ? (
    <Redirect push to={firstAcctPage || '/account/profile'} />
  ) : (
    <>
      <h2 className="text-center">Welcome Back!</h2>
      <Container className="mt-4 mb-5">
        <Form noValidate validated={validated} onSubmit={submitWrapper}>
          <Form.Group controlId="formBasicEmail">
            <Form.Label>E-mail address</Form.Label>
            <Form.Control
              type="email"
              placeholder="E-mail address"
              onChange={(e) => {
                if (validated) {
                  setValidated(false);
                }
                handleKeyPress('email', e);
              }}
              required
              isInvalid={
                submitted && (!data.email || validateEmail(data.email))
              }
            />
            <Form.Control.Feedback type="invalid">
              Please provide an e-mail address.
            </Form.Control.Feedback>
          </Form.Group>
          <Form.Group controlId="formBasicPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control
              type="password"
              placeholder="Password"
              onChange={(e) => {
                if (validated) {
                  setValidated(false);
                }
                handleKeyPress('password', e);
              }}
              required
              isInvalid={submitted && !data.password}
            />
            <Form.Control.Feedback type="invalid">
              Please provide a password.
            </Form.Control.Feedback>
            <Link
              className="font-weight-light"
              style={{ color: 'gray' }}
              to="/forgot_password"
            >
              Forgot Password?
            </Link>
          </Form.Group>
          <div className="text-center">
            <Button variant="info" type="submit" className="mt-5 mb-3" block>
              Login
            </Button>
          </div>
        </Form>
        <p className="font-weight-bold side-line-text">or</p>
        <div className="text-center">
          <GoogleOAuthButton />
        </div>
      </Container>
    </>
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
    firstAcctPage: state.userStore.firstAcctPage,
  };
};

const mapDispatchToProps = {
  attemptLogin,
  validateEmail,
  openGoogleOauthWindow,
};
export default connect(mapStateToProps, mapDispatchToProps)(Login);
