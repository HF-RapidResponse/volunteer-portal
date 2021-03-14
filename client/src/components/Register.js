import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Button, Form, Container, Row, Col, Alert } from 'react-bootstrap';
import { Redirect } from 'react-router-dom';
import useForm from './hooks/useForm';
import { attemptCreateAccount } from '../store/user-slice';
import LinesAroundOr from './LinesAroundOr';
import OAuthGroup from './OAuth/OAuthGroup';
import '../styles/register-login.scss';

function Register(props) {
  document.title = 'HF Volunteer Portal - Create an Account';
  const { user, attemptCreateAccount } = props;
  const {
    handleChange,
    handleSubmit,
    data,
    submitted,
    setSubmitted,
    validated,
    setValidated,
    errors,
  } = useForm(attemptCreateAccount);
  const path = window.location.pathname;

  /**
   * simple helper function that handles form submission by calling several other functions
   * @param {*} e - event object
   */
  const submitWrapper = (e) => {
    setValidated(true);
    handleSubmit(e);
  };

  /**
   * simple helper function that checks for enter key to do for submission
   * @param {Object} e - event object
   */
  function handleKeyPress(key, e) {
    if (validated) {
      setValidated(false);
    }
    if (e.key === 'Enter') {
      submitWrapper(e);
    } else {
      handleChange(key, e.target.value);
    }
  }

  return (validated && submitted) || user ? (
    <Redirect push to="/account/profile" />
  ) : (
    <>
      <h2 className="text-center">
        Create an account with us to manage your volunteering experience.
      </h2>
      <div className="mt-5 mb-5">
        <Row>
          <Col
            xs={12}
            xl={5}
            className="d-flex justify-content-center flex-column"
          >
            <OAuthGroup />
          </Col>
          <Col xs={12} xl={2}>
            <LinesAroundOr />
          </Col>
          <Col xs={12} xl={5}>
            <h3 className="text-center mt-2 mb-4" style={{ color: 'gray' }}>
              Register with e-mail
            </h3>
            <Form
              noValidate
              validated={validated}
              onSubmit={submitWrapper}
              className="mt-2 mb-2"
            >
              <Row>
                <Col xs={12} lg={6} xl={12}>
                  <Form.Group controlId="formFirstName">
                    <Form.Label>First Name</Form.Label>
                    <Form.Control
                      type="name"
                      placeholder="First Name"
                      onChange={(e) => {
                        handleKeyPress('first_name', e);
                      }}
                      isValid={submitted && !errors.firstName}
                      isInvalid={errors.firstName}
                      required
                    />
                    <Form.Control.Feedback type="invalid">
                      {!data.first_name
                        ? 'Please provide a last name.'
                        : 'Please only use alphanumeric or unicode characters.'}
                    </Form.Control.Feedback>
                  </Form.Group>
                </Col>
                <Col xs={12} lg={6} xl={12}>
                  <Form.Group controlId="formLastName">
                    <Form.Label>Last Name</Form.Label>
                    <Form.Control
                      type="name"
                      placeholder="Last Name"
                      onChange={(e) => {
                        handleKeyPress('last_name', e);
                      }}
                      isValid={submitted && !errors.lastName}
                      isInvalid={errors.lastName}
                      required
                    />
                    <Form.Control.Feedback type="invalid">
                      {!data.last_name
                        ? 'Please provide a last name.'
                        : 'Please only use alphanumeric or unicode characters.'}
                    </Form.Control.Feedback>
                  </Form.Group>
                </Col>
              </Row>
              <Form.Group controlId="formUsername">
                <Form.Label>Username</Form.Label>
                <Form.Control
                  type="username"
                  placeholder="Username"
                  onChange={(e) => {
                    handleKeyPress('username', e);
                  }}
                  isValid={submitted && !errors.username}
                  isInvalid={errors.username}
                  required
                />
                <Form.Control.Feedback type="invalid">
                  {!data.last_name
                    ? 'Please provide a username.'
                    : 'Please only use alphanumeric or unicode characters.'}
                </Form.Control.Feedback>
              </Form.Group>
              <Form.Group controlId="formBasicEmail">
                <Form.Label>E-mail address</Form.Label>
                <Form.Control
                  type="email"
                  placeholder="E-mail address"
                  onChange={(e) => {
                    handleKeyPress('email', e);
                  }}
                  isValid={submitted && !errors.email}
                  isInvalid={errors.email}
                  required
                />
                <Form.Control.Feedback type="invalid">
                  {'Please provide a valid e-mail address.'}
                </Form.Control.Feedback>
              </Form.Group>
              <Form.Group controlId="formBasicPassword">
                <Form.Label>Password</Form.Label>
                <Form.Control
                  type="password"
                  placeholder="Password"
                  onChange={(e) => {
                    handleKeyPress('password', e);
                  }}
                  isValid={submitted && !errors.password}
                  isInvalid={errors.password}
                  required
                />
                <Form.Control.Feedback type="invalid">
                  Please enter a password between 6 and 20 characters long with
                  at least 1 letter, 1 number, and 1 special character.
                </Form.Control.Feedback>
              </Form.Group>
              <Form.Group controlId="formRetypePassword">
                <Form.Label>Re-enter your password</Form.Label>
                <Form.Control
                  type="password"
                  placeholder="Repeat password"
                  onChange={(e) => {
                    handleKeyPress('retypePass', e);
                  }}
                  isValid={submitted && !errors.retypePass}
                  isInvalid={errors.retypePass}
                  required
                />
                <Form.Control.Feedback type="invalid">
                  {!data.retypePass
                    ? 'Please re-type your password.'
                    : 'New password and retyped password do not match.'}
                </Form.Control.Feedback>
              </Form.Group>
              <Alert variant="danger" className={!errors.api ? 'd-none' : null}>
                {errors.api}
              </Alert>
              <div className="text-center">
                <Button
                  variant="info"
                  type="submit"
                  className="mt-4 mb-4 pt-2 pb-2 pl-5 pr-5"
                >
                  Create an Account
                </Button>
              </div>
            </Form>
          </Col>
        </Row>
      </div>
    </>
  );
}
const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};
const mapDispatchToProps = { attemptCreateAccount };

export default connect(mapStateToProps, mapDispatchToProps)(Register);
