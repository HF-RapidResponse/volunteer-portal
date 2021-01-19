import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { Button, Container, Row, Col, Form } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import RecruitmentSocialShare from './RecruitmentSocialShare';
import useForm from './hooks/useForm';

function Register(props) {
  document.title = 'HF Volunteer Portal - Create an Account';
  const [submitted, setSubmitted] = useState(false);
  const [validated, setValidated] = useState(false);
  const { attemptLogin, user } = props;
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

  return (validated && submitted) || user ? (
    <Redirect push to="/account/profile" />
  ) : (
    <>
      <h2 className="text-center">
        Create an account with us to manage your volunteering experience.
      </h2>
      <div className="mt-5 mb-5">
        <h3 className="text-center" style={{ color: 'gray' }}>
          Create your account.
        </h3>
        <Form
          noValidate
          validated={validated}
          className="ml-5 mr-5"
          onSubmit={submitWrapper}
        >
          <Form.Group controlId="formUsername">
            <Form.Label>Name</Form.Label>
            <Form.Control
              type="name"
              placeholder="Name"
              onChange={(e) => handleKeyPress('username', e)}
            />
          </Form.Group>
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
          </Form.Group>
          <Form.Group controlId="formRetypePassword">
            <Form.Label>Re-enter your password</Form.Label>
            <Form.Control
              type="password"
              placeholder="Repeat password"
              onChange={(e) => handleKeyPress('retypePass', e)}
            />
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
      </div>
    </>
  );
}

export default Register;
