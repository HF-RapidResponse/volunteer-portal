import React, { useState } from 'react';
import { connect } from 'react-redux';
import useForm from './hooks/useForm';
import { Button, Form, Container } from 'react-bootstrap';
import {
  attemptLogin,
  validateEmail,
  googleOauthLogin,
  openGoogleOauthWindow,
} from '../store/user-slice.js';
import { Redirect } from 'react-router-dom';
import { Link } from 'react-router-dom';
import { GoogleLogin } from 'react-google-login';
import GoogleLogo from './GoogleLogo';

function Login(props) {
  const [submitted, setSubmitted] = useState(false);
  const [validated, setValidated] = useState(false);
  const {
    attemptLogin,
    user,
    firstAcctPage,
    validateEmail,
    googleOauthLogin,
    openGoogleOauthWindow,
  } = props;
  const { handleSubmit, handleChange, data } = useForm(attemptLogin);
  const path = window.location.pathname;

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

  const errorGoogle = (response) => {
    console.error(response);
  };

  return (validated && submitted) || user ? (
    <Redirect push to={firstAcctPage || '/account/profile'} />
  ) : (
    <>
      <h2 className="text-center">Welcome Back!</h2>
      <Container className="mt-4 mb-5">
        <Form
          noValidate
          validated={validated}
          // className="ml-5 mr-5"
          onSubmit={submitWrapper}
        >
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
            <p className="font-weight-bold side-line-text">or</p>
            <Button
              variant="primary"
              onClick={() => {
                const baseUrl =
                  window.location.port === '8000'
                    ? 'http://localhost:8081'
                    : window.location.origin;
                const name = 'Google OAuth Login';
                const windowFeatures =
                  'toolbar=no, menubar=no, width=600, height=700, top=100, left=100';
                const oauthUrl = `${baseUrl}/api/login?provider=google`;
                console.log('What is oauthUrl?', oauthUrl);
                window.location.href = oauthUrl;
                // const windowObjectReference = window.open(
                //   oauthUrl,
                //   name,
                //   windowFeatures
                // );
                // windowObjectReference.focus();
              }}
            >
              Login with Google
            </Button>
            {/* <GoogleLogin
              clientId="899853639312-rluooarpraulr242vuvfqejefmg1ii8d.apps.googleusercontent.com"
              buttonText="Login with Google"
              onSuccess={googleOauthLogin}
              onFailure={errorGoogle}
              cookiePolicy={'single_host_origin'}
              className="btn-block"
            /> */}
          </div>
        </Form>
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
  googleOauthLogin,
  openGoogleOauthWindow,
};
export default connect(mapStateToProps, mapDispatchToProps)(Login);
