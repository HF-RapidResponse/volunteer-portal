import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Button, Form, Container, Row, Col, Alert } from 'react-bootstrap';
import { Redirect } from 'react-router-dom';
import useForm from 'components/hooks/useForm';
import { attemptRegister } from 'store/user-slice';
import LinesAroundOr from './LinesAroundOr';
import OAuthGroup from 'components/oauth/OAuthGroup';
import 'styles/register-login.scss';

function Register(props) {
  document.title = 'HF Volunteer Portal - Create an Account';
  const [pendingSubmit, setPendingSubmit] = useState(false);
  const { user, attemptRegister } = props;
  const {
    handleChange,
    handleSubmit,
    data,
    submitted,
    setSubmitted,
    validated,
    setValidated,
    errors,
  } = useForm(attemptRegister);
  const path = window.location.pathname;

  const submitWrapper = async (e) => {
    setPendingSubmit(true);
    await handleSubmit(e);
    setPendingSubmit(false);
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

  return user && !pendingSubmit ? (
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
                      type="text"
                      placeholder="First Name"
                      onChange={(e) => {
                        handleKeyPress('first_name', e);
                      }}
                      isValid={validated && !errors.firstName}
                      isInvalid={!!errors.firstName}
                      placeholder="Enter first name here (required)"
                      required
                    />
                    <Form.Control.Feedback type="invalid">
                      {!data.first_name
                        ? 'Please provide a first name.'
                        : errors.firstName}
                    </Form.Control.Feedback>
                  </Form.Group>
                </Col>
                <Col xs={12} lg={6} xl={12}>
                  <Form.Group controlId="formLastName">
                    <Form.Label>Last Name</Form.Label>
                    <Form.Control
                      type="text"
                      placeholder="Enter last name here (optional)"
                      onChange={(e) => {
                        handleKeyPress('last_name', e);
                      }}
                      isValid={validated && !errors.lastName}
                      isInvalid={!!errors.lastName}
                      placeholder="Enter last name here (optional)"
                    />
                    <Form.Control.Feedback type="invalid">
                      {errors.lastName}
                    </Form.Control.Feedback>
                  </Form.Group>
                </Col>
              </Row>
              <Form.Group controlId="formUsername">
                <Form.Label>Username</Form.Label>
                <Form.Control
                  type="text"
                  onChange={(e) => {
                    handleKeyPress('username', e);
                  }}
                  isValid={validated && !errors.username}
                  isInvalid={!!errors.username}
                  required
                  placeholder="Enter username here (required)"
                />
                <Form.Control.Feedback type="invalid">
                  {!data.username
                    ? 'Please provide a username.'
                    : errors.username}
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
                  isValid={validated && !errors.email}
                  isInvalid={!!errors.email}
                  required
                  placeholder="Enter e-mail address here (required)"
                />
                <Form.Control.Feedback type="invalid">
                  {!data.email
                    ? 'Please provide an e-mail address.'
                    : errors.email}
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
                  isValid={validated && !errors.password}
                  isInvalid={!!errors.password}
                  placeholder="Enter password here (required)"
                  required
                />
                <Form.Control.Feedback type="invalid">
                  {!data.password
                    ? 'Please provide a password'
                    : errors.password}
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
                  isValid={validated && !errors.retypePass}
                  isInvalid={!!errors.retypePass}
                  placeholder="Retype password here (required)"
                  required
                />
                <Form.Control.Feedback type="invalid">
                  {!data.retypePass
                    ? 'Please re-type your password.'
                    : errors.retypePass}
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
const mapDispatchToProps = { attemptRegister };

export default connect(mapStateToProps, mapDispatchToProps)(Register);
