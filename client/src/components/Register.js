import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Button, Form, Container } from 'react-bootstrap';
import { Redirect } from 'react-router-dom';
import useForm from './hooks/useForm';
import { attemptCreateAccount, validatePassword } from '../store/user-slice';

function Register(props) {
  document.title = 'HF Volunteer Portal - Create an Account';
  // const [submitted, setSubmitted] = useState(false);
  // const [validated, setValidated] = useState(false);
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
  function submitWrapper(e) {
    setValidated(true);
    setSubmitted(handleSubmit(e));
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

  return (validated && submitted) || user ? (
    <Redirect push to="/account/profile" />
  ) : (
    <>
      <h2 className="text-center">
        Create an account with us to manage your volunteering experience.
      </h2>
      <Container className="mt-5 mb-5">
        <h3 className="text-center" style={{ color: 'gray' }}>
          Create your account.
        </h3>
        <Form noValidate validated={validated} onSubmit={submitWrapper}>
          <Form.Group controlId="formUsername">
            <Form.Label>Name</Form.Label>
            <Form.Control
              type="name"
              placeholder="Name"
              onChange={(e) => {
                if (validated) {
                  setValidated(false);
                }
                handleKeyPress('name', e);
              }}
              isInvalid={!!errors.name}
              required
            />
            <Form.Control.Feedback type="invalid">
              {errors.name || 'Please provide a name.'}
            </Form.Control.Feedback>
          </Form.Group>
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
              isInvalid={!!errors.email}
              required
            />
            <Form.Control.Feedback type="invalid">
              {errors.email || 'Please provide a valid e-mail address.'}
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
              isInvalid={!!errors.password}
              // isValid={submitted && validatePassword(data.password)}
              required
            />
            <Form.Control.Feedback type="invalid">
              {errors.password || 'Please provide a password.'}
            </Form.Control.Feedback>
          </Form.Group>
          <Form.Group controlId="formRetypePassword">
            <Form.Label>Re-enter your password</Form.Label>
            <Form.Control
              type="password"
              placeholder="Repeat password"
              onChange={(e) => {
                if (validated) {
                  setValidated(false);
                }
                handleKeyPress('retypePass', e);
              }}
              isInvalid={!!errors.retypePass}
              // isValid={validated && !errors.retypePass}
              required
            />
            <Form.Control.Feedback type="invalid">
              {errors.retypePass || 'Please re-type your password.'}
            </Form.Control.Feedback>
          </Form.Group>
          <div className="text-center">
            <Button
              variant="info"
              type="submit"
              className="mt-3 mb-3 pt-2 pb-2 pl-5 pr-5"
            >
              Create an Account
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
  };
};
const mapDispatchToProps = { attemptCreateAccount };

export default connect(mapStateToProps, mapDispatchToProps)(Register);
