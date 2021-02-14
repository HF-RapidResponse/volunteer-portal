import React, { useState } from 'react';
import { connect } from 'react-redux';
import useForm from './hooks/useForm';
import { Button, Form, Container } from 'react-bootstrap';
import {
  attemptLogin,
  validateEmail,
  oauthLogin,
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
    oauthLogin,
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

  const getRequestUrl = (oauthLogin) => {
    // const host =
    //   window.location.hostname === 'localhost'
    //     ? 'http://localhost:8000'
    //     : window.location.hostname;
    const url = `/api/login?provider=${oauthLogin}`;
    console.log('url to return:', url);
    return url;
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
            <p className="font-weight-bold">or</p>
            {/* <GoogleLogin
              // clientId="658977310896-knrl3gka66fldh83dao2rhgbblmd4un9.apps.googleusercontent.com"
              clientId="102560006154572955509"
              buttonText="Login with Google"
              onSuccess={responseGoogle}
              onFailure={responseGoogle}
              onClick={() => attemptLogin({ oauthLogin: 'google' })}
              cookiePolicy={'single_host_origin'}
              className="btn-block"
            /> */}
            {/* <Button
              variant="primary"
              onClick={() => props.history.push(getRequestUrl('google'))}
            >
              Login with Google
            </Button> */}
            <GoogleLogin
              clientId="899853639312-rluooarpraulr242vuvfqejefmg1ii8d.apps.googleusercontent.com"
              //clientId="102560006154572955509"
              buttonText="Login with Google"
              onSuccess={oauthLogin}
              onFailure={errorGoogle}
              // onClick={() => oauthLogin({ oauthLogin: 'google' })}
              cookiePolicy={'single_host_origin'}
              className="btn-block"
            />
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

const mapDispatchToProps = { attemptLogin, validateEmail, oauthLogin };
export default connect(mapStateToProps, mapDispatchToProps)(Login);
