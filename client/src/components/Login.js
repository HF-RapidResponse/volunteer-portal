import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import useForm from './hooks/useForm';
import { Button, Form, Container, Row, Col } from 'react-bootstrap';
import { attemptLogin } from '../store/user-slice.js';
import { Redirect } from 'react-router-dom';
import { Link } from 'react-router-dom';
import GoogleOAuthButton from './OAuth/GoogleOAuthButton';
import GitHubOAuthButton from './OAuth/GitHubOAuthButton';
import LoadingSpinner from './LoadingSpinner';
import LinesAroundOr from './LinesAroundOr';
import OAuthGroup from './OAuth/OAuthGroup';
import '../styles/register-login.scss';

function Login(props) {
  const [loading, setLoading] = useState(false);
  const { attemptLogin, user, firstAcctPage } = props;
  const {
    validated,
    submitted,
    errors,
    handleSubmit,
    handleChange,
    data,
  } = useForm(attemptLogin);
  const params = new URLSearchParams(window.location.search);

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
        <Form noValidate validated={validated} onSubmit={handleSubmit}>
          <Form.Group controlId="formBasicEmail">
            <Form.Label>E-mail address</Form.Label>
            <Form.Control
              type="email"
              placeholder="E-mail address"
              onChange={(e) => {
                handleChange('email', e.target.value);
              }}
              required
              isInvalid={validated && (!data.email || errors.email)}
            />
            <Form.Control.Feedback type="invalid">
              {!data.email
                ? 'Please provide an e-mail address.'
                : 'Invalid e-mail format'}
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
              isInvalid={
                validated &&
                (!data.password || errors.password || errors.message)
              }
            />
            <Form.Control.Feedback type="invalid">
              {!data.password ? 'Please provide a password.' : errors.message}
            </Form.Control.Feedback>
            <div className="mt-2 mb-2">
              <Link
                className="font-weight-light"
                style={{ color: 'gray' }}
                to="/forgot_password"
              >
                Forgot Password?
              </Link>
            </div>
          </Form.Group>
          <div className="text-center">
            <Button variant="info" type="submit" className="mt-5 mb-3" block>
              Login
            </Button>
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
};

export default connect(mapStateToProps, mapDispatchToProps)(Login);
