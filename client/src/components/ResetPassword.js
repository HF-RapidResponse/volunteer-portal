import React, { useEffect, useState } from 'react';
import { Button, Form } from 'react-bootstrap';

import useForm from 'components/hooks/useForm';
import { attemptResetPassword, getSettingsFromHash } from 'store/user-slice';
import LoadingSpinner from './LoadingSpinner';

function ResetPassword(props) {
  const [loading, setLoading] = useState(false);
  // const [errorLoading, setErrorLoading] = useState(false);
  const [settings, setSettings] = useState(null);

  useEffect(async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams(window.location.search);
      const hash = params.get('hash');
      const loadedSettings = await getSettingsFromHash(hash);
      setSettings(loadedSettings);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, []);

  const {
    validated,
    submitted,
    errors,
    handleSubmit,
    handleChange,
    data,
    resetForm,
  } = useForm(attemptResetPassword, { uuid: settings ? settings.uuid : null });

  return loading ? (
    <LoadingSpinner />
  ) : settings && submitted ? (
    <>
      <h2 className="text-center">Password reset successfully!</h2>
      <p>
        You can now go back to the
        <Link to="/login">login page</Link> and log in with your new password.
      </p>
    </>
  ) : settings ? (
    <>
      <h2>Reset Password</h2>
      <Form
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
            isInvalid={validated && (!data.password || !!errors.password)}
            required
          />
          <Form.Control.Feedback type="invalid">
            {errors.password}
          </Form.Control.Feedback>
        </Form.Group>
        <Form.Group controlId="reset-retype-password">
          <Form.Label>Retype password</Form.Label>
          <Form.Control
            type="password"
            placeholder="Enter new password (required)"
            onChange={(e) => {
              handleChange('retypePass', e.target.value);
            }}
            isInvalid={validated && (!data.retypePass || !!errors.retypePass)}
            required
          />
          <Form.Control.Feedback type="invalid">
            {errors.retypePass}
          </Form.Control.Feedback>
        </Form.Group>
        <div className="text-center">
          <Button variant="info" type="submit" className="mt-5 mb-3" block>
            Change Password
          </Button>
        </div>
      </Form>
    </>
  ) : (
    <>
      <h2 className="text-center">
        Oops, it looks like this password reset link is invalid or expired!
      </h2>
      <p>
        Please try again by requesting a password reset on the{' '}
        <Link to="/login">login page.</Link>
      </p>
    </>
  );
}

export default ResetPassword;
