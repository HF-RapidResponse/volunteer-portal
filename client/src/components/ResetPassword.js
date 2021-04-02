import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Button, Form } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import useForm from 'components/hooks/useForm';
import {
  attemptResetPassword,
  getSettingsFromHash,
} from 'store/user-slice/reset-password';
import LoadingSpinner from './LoadingSpinner';
import { startLogout } from 'store/user-slice';

function ResetPassword(props) {
  const [loading, setLoading] = useState(false);
  const [errorLoading, setErrorLoading] = useState(false);
  const { user, cookies, startLogout } = props;
  const {
    validated,
    submitted,
    errors,
    handleSubmit,
    handleChange,
    data,
  } = useForm(attemptResetPassword);

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams(window.location.search);
    const hash = params.get('hash');
    getSettingsFromHash(hash)
      .then((response) => handleChange('uuid', response.uuid))
      .catch(() => setErrorLoading(true))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (user) {
      startLogout(cookies);
    }
  }, [user]);

  return loading ? (
    <LoadingSpinner />
  ) : submitted ? (
    <div className="mt-5 mb-5 text-center">
      <h2 className="mt-3 mb-3">Password reset successfully!</h2>
      <p className="mt-3 mb-3">
        You can now go back to the <Link to="/login">login page</Link> and log
        in with your new password.
      </p>
    </div>
  ) : data && data.uuid ? (
    <div className="mt-5 mb-5">
      <h2 className="text-center">Reset Password</h2>
      <Form
        id="acct-reset-pw-form"
        noValidate
        validated={validated}
        onSubmit={handleSubmit}
        className="mt-5 mb-5"
      >
        <Form.Group controlId="reset-new-password">
          <Form.Label>New password</Form.Label>
          <Form.Control
            type="password"
            placeholder="Enter new password (required)"
            onChange={(e) => {
              handleChange('password', e.target.value);
            }}
            isInvalid={!!errors.password}
            required
          />
          <Form.Control.Feedback type="invalid">
            {!data.password ? 'Please enter a password' : errors.password}
          </Form.Control.Feedback>
        </Form.Group>
        <Form.Group controlId="reset-retype-password">
          <Form.Label>Retype password</Form.Label>
          <Form.Control
            type="password"
            placeholder="Retype new password (required)"
            onChange={(e) => {
              handleChange('retypePass', e.target.value);
            }}
            isInvalid={!!errors.retypePass}
            required
          />
          <Form.Control.Feedback type="invalid">
            {!data.retypePass
              ? 'Please retype your password.'
              : errors.retypePass}
          </Form.Control.Feedback>
        </Form.Group>
        <div className="text-center">
          <Button variant="info" type="submit" className="mt-5 mb-3" block>
            Change Password
          </Button>
        </div>
      </Form>
    </div>
  ) : errorLoading ? (
    <div className="mt-5 mb-5 text-center">
      <h2 className="mt-3 mb-3">
        Oops, it looks like this password reset link is invalid or expired!
      </h2>
      <p className="mt-3 mb-3">
        Please try again by requesting a password reset on the{' '}
        <Link to="/login">login page.</Link>
      </p>
    </div>
  ) : null;
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

const mapDispatchToProps = {
  startLogout,
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(ResetPassword)
);
