import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { Button, Container, Row, Col, Form } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import RecruitmentSocialShare from './RecruitmentSocialShare';
import useForm from './hooks/useForm';

function CreateAccount(props) {
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
      <h2>Welcome to the portal!</h2>
      <Form
        noValidate
        validated={validated}
        className="fade-in"
        onSubmit={submitWrapper}
      >
        <Form.Group controlId="formUsername">
          <Form.Label>Username?</Form.Label>
          <Form.Control
            type="username"
            placeholder="Username or just email below"
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
        <div className="text-center">
          <Button variant="info" type="submit" className="mt-2 mb-2">
            Login
          </Button>
        </div>
      </Form>
    </>
  );
}

export default CreateAccount;
