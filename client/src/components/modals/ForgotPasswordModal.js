import React from 'react';
import { Modal } from 'react-bootstrap';
import { Button, Form } from 'react-bootstrap';

import useForm from 'components/hooks/useForm';
import { attemptSendResetEmail } from 'store/user-slice';

function ForgotPasswordModal(props) {
  const {
    validated,
    submitted,
    errors,
    handleSubmit,
    handleChange,
    data,
    resetForm,
  } = useForm(attemptSendResetEmail);

  const clearFormAndHide = () => {
    props.onHide();
    resetForm();
  };

  return (
    <Modal {...props} size="lg" onExited={clearFormAndHide} centered>
      <Modal.Header closeButton />
      {submitted ? (
        <Modal.Body>
          <h4 className="m-4">
            If we have you on record, we will send you an e-mail to reset your
            password.
          </h4>
          <div className="text-right">
            <Button
              variant="outline-info"
              className="m-4 py-2 px-4"
              onClick={clearFormAndHide}
            >
              Return
            </Button>
          </div>
        </Modal.Body>
      ) : (
        <Modal.Body>
          <h2 className="text-center mt-4 mb-4">Reset Password</h2>
          <Form
            noValidate
            validated={validated}
            onSubmit={handleSubmit}
            className="mt-5 mb-5"
          >
            <Form.Group controlId="forgot-password-request">
              <Form.Label>Username or e-mail address</Form.Label>
              <Form.Control
                type="text"
                placeholder="Enter username or e-mail address"
                onChange={(e) => {
                  handleChange('username_or_email', e.target.value);
                }}
                isInvalid={
                  validated &&
                  (!data.username_or_email || !!errors.usernameOrEmail)
                }
                required
              />
              <Form.Control.Feedback type="invalid">
                This is not a valid username or e-mail format. Please try again.
              </Form.Control.Feedback>
            </Form.Group>
            <div className="text-center">
              <Button variant="info" type="submit" className="mt-5 mb-3" block>
                Reset Password
              </Button>
            </div>
          </Form>
        </Modal.Body>
      )}
    </Modal>
  );
}

export default ForgotPasswordModal;
