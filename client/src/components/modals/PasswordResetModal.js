import React from 'react';
import { Modal } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Button, Form, Container, Row, Col } from 'react-bootstrap';

import useForm from 'components/hooks/useForm';
import { attemptSendResetEmail } from 'store/user-slice';

function PasswordResetModal(props) {
  const {
    validated,
    submitted,
    errors,
    handleSubmit,
    handleChange,
    data,
  } = useForm(attemptSendResetEmail);

  return (
    <Modal {...props} size="lg" centered>
      <Modal.Header closeButton />
      <Modal.Body>
        <h2 className="text-center mt-4 mb-4">Reset Password</h2>
        <Form
          noValidate
          validated={validated}
          onSubmit={handleSubmit}
          className="mt-5 mb-5"
        >
          <Form.Group controlId="reset-password-form">
            <Form.Label>Username or e-mail address</Form.Label>
            <Form.Control
              type="text"
              placeholder="Enter username or e-mail address (required)"
              onChange={(e) => {
                handleChange('username_or_email', e.target.value);
              }}
              isInvalid={
                validated &&
                (!data.username_or_email || Object.keys(errors).length)
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
    </Modal>
  );
}

// const mapDispatchToProps = {
//   attemptSendResetEmail,
// };

// export default connect(null, mapDispatchToProps)(PasswordReset);
export default PasswordResetModal;
