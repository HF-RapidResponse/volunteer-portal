import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Col, Row, Alert } from 'react-bootstrap';
import { withCookies } from 'react-cookie';

import useForm from 'components/hooks/useForm';
import {
  attemptChangePassword,
  deleteUser,
  basicPropUpdate,
} from 'store/user-slice';

function Settings(props) {
  const [disableForm, setDisableForm] = useState(false);
  const {
    user,
    tokenRefreshTime,
    deleteUser,
    cookies,
    basicPropUpdate,
    attemptChangePassword,
  } = props;
  const {
    handleChange,
    handleSubmit,
    data,
    submitted,
    validated,
    setValidated,
    errors,
    resetForm,
  } = useForm(attemptChangePassword, { uuid: user.uuid, tokenRefreshTime });

  const deletePrompt = () => {
    const userWantsToDelete = confirm(
      'Are you sure you want to delete your account? This cannot be undone.'
    );
    if (userWantsToDelete) {
      deleteUser(user.uuid, cookies);
    }
  };

  const clearFormComponent = () => {
    const formComponent = document.getElementById('acct-settings-form');
    formComponent.reset();
  };

  useEffect(() => {
    if (validated && submitted) {
      setDisableForm(true);
      setTimeout(() => {
        clearFormComponent();
        resetForm();
        setDisableForm(false);
      }, 3000);
    }
  }, [validated, submitted]);

  const submitWrapper = async (e) => {
    if (data.oldPass) {
      await handleSubmit(e);
    } else {
      e.preventDefault();
      e.stopPropagation();
    }
  };

  return user ? (
    <>
      <Form
        id="acct-settings-form"
        className="p-4"
        style={{ background: 'white' }}
        noValidate
        validated={validated}
        onSubmit={submitWrapper}
      >
        <h4 className="mb-5">Change Account</h4>
        <Row className="mt-2 mb-2">
          <Col xs={8}>
            <p>Organizers can see my profile</p>
          </Col>
          <Col xs={4}>
            <Form.Switch
              id="organizers-can-see-profile-switch"
              className="custom-switch-md"
              checked={user.organizers_can_see}
              onChange={() =>
                basicPropUpdate({
                  user,
                  key: 'organizers_can_see',
                  newVal: !user.organizers_can_see,
                  tokenRefreshTime,
                })
              }
            />
          </Col>
        </Row>
        <Row className="mt-2 mb-2">
          <Col xs={8}>
            <p>Other volunteers can see my profile</p>
          </Col>
          <Col xs={4}>
            <Form.Switch
              id="other-vounteers-can-see-profile-switch"
              className="custom-switch-md"
              checked={user.volunteers_can_see}
              onChange={() =>
                basicPropUpdate({
                  user,
                  key: 'volunteers_can_see',
                  newVal: !user.volunteers_can_see,
                  tokenRefreshTime,
                })
              }
            />
          </Col>
        </Row>
        <Form.Group className={user.oauth ? 'd-none' : null}>
          <div className={'mt-3 ' + (data.oldPass ? 'mb-5' : 'mb-4')}>
            <Form.Label>Change Password</Form.Label>
            <Form.Control
              type="password"
              placeholder="Old Password"
              id="old-pass"
              onChange={(e) => {
                handleChange('oldPass', e.target.value);
              }}
              isValid={submitted && !errors.oldPassInvalid}
              isInvalid={errors.oldPassInvalid}
              required
              disabled={disableForm}
              placeholder="Enter current password here (required)"
            />
            <Form.Control.Feedback type="invalid">
              Password is invalid!
            </Form.Control.Feedback>
          </div>
          <div className={data.oldPass || submitted ? 'mt-5 mb-3' : 'd-none'}>
            <Form.Label>New Password</Form.Label>
            <Form.Control
              type="password"
              id="new-pass"
              onChange={(e) => {
                handleChange('newPass', e.target.value);
              }}
              isValid={submitted && !errors.newPassInvalid}
              isInvalid={errors.newPassInvalid}
              required
              disabled={disableForm}
              placeholder="Enter new password here (required)"
            />
            <Form.Control.Feedback type="invalid">
              Passwords must be between 6 to 20 characters with 1 letter, 1
              number, and one special character.
            </Form.Control.Feedback>
          </div>
          <div className={data.oldPass ? 'mt-3 mb-3' : 'd-none'}>
            <Form.Label>Retype Password</Form.Label>
            <Form.Control
              type="password"
              id="retype-pass"
              onChange={(e) => {
                handleChange('retypePass', e.target.value);
              }}
              isValid={submitted}
              isInvalid={errors.newPassRetypeMismatch}
              required
              disabled={disableForm}
              placeholder="Retype new password here (required)"
            />
            <Form.Control.Feedback type="invalid">
              {!data.newPass || !data.retypePass
                ? 'New password or retype cannot be blank'
                : 'Passwords do not match!'}
            </Form.Control.Feedback>
            <Form.Control.Feedback type="valid">
              {submitted ? 'Password change successful' : null}
            </Form.Control.Feedback>
            <Row>
              <Col xs={12} xl={6} className="text-center">
                <Button
                  variant="info"
                  className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4"
                  type="submit"
                >
                  Change Password
                </Button>
              </Col>
              <Col xs={12} xl={6} className="text-center">
                <Button
                  variant="outline-secondary"
                  className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4"
                  onClick={() => {
                    clearFormComponent();
                    resetForm();
                  }}
                >
                  Cancel
                </Button>
              </Col>
            </Row>
          </div>
        </Form.Group>
      </Form>
      <Form className="mt-5 mb-5" style={{ background: 'white' }}>
        <Form.Group>
          <Row className="align-items-center">
            <Col xs={12} sm={6} className="text-center">
              <p className="mt-4 mb-4">Delete Account</p>
            </Col>
            <Col xs={12} sm={6} className="text-center">
              <Button
                variant="danger"
                className="mt-2 mt-sm-4 mb-4 ml-2 mr-2 pt-2 pb-2 pr-4 pl-4"
                onClick={() => deletePrompt()}
              >
                Delete my Account
              </Button>
            </Col>
          </Row>
        </Form.Group>
      </Form>
    </>
  ) : (
    <Redirect push to="/login" />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
    tokenRefreshTime: state.userStore.tokenRefreshTime,
  };
};

const mapDispatchToProps = {
  deleteUser,
  basicPropUpdate,
  attemptChangePassword,
};
export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(Settings)
);
