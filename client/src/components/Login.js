import React, { useState } from 'react';
import { connect } from 'react-redux';
import useForm from './hooks/useForm';
import { Button, Form, Container } from 'react-bootstrap';
import { attemptLogin } from '../store/user-slice.js';
import { Redirect } from 'react-router-dom';
import { Link } from 'react-router-dom';
import { GoogleLogin } from 'react-google-login';

function Login(props) {
  const [submitted, setSubmitted] = useState(false);
  const [validated, setValidated] = useState(false);
  const { attemptLogin, user, firstAcctPage } = props;
  const { handleSubmit, handleChange } = useForm(attemptLogin);
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

  const responseGoogle = (response) => {
    console.log(response);
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
          {/* <Form.Group controlId="formUsername">
            <Form.Label>Username?</Form.Label>
            <Form.Control
              type="username"
              placeholder="Username or just email below"
              onChange={(e) => handleKeyPress('username', e)}
            />
          </Form.Group> */}
          <Form.Group controlId="formBasicEmail">
            <Form.Label>E-mail address</Form.Label>
            <Form.Control
              type="email"
              placeholder="E-mail address"
              onChange={(e) => handleKeyPress('email', e)}
            />
          </Form.Group>
          <Form.Group controlId="formBasicPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control
              type="password"
              placeholder="Password"
              onChange={(e) => handleKeyPress('password', e)}
            />
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
          <p className="text-center font-weight-bold">or</p>
          <div className="text-center">
            <GoogleLogin
              clientId="658977310896-knrl3gka66fldh83dao2rhgbblmd4un9.apps.googleusercontent.com"
              buttonText="Login with Google"
              onSuccess={responseGoogle}
              onFailure={responseGoogle}
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

const mapDispatchToProps = { attemptLogin };
export default connect(mapStateToProps, mapDispatchToProps)(Login);
