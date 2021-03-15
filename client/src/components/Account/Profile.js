import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Col, Row } from 'react-bootstrap';
import {
  basicPropUpdate,
  attemptAccountUpdate,
  AccountReqBody,
} from '../../store/user-slice';
import useForm from '../hooks/useForm';
import { isEqual } from 'lodash';

function Profile(props) {
  const [disableForm, setDisableForm] = useState(false);
  const {
    user,
    tokenRefreshTime,
    basicPropUpdate,
    attemptAccountUpdate,
  } = props;
  const {
    handleChange,
    handleSubmit,
    data,
    submitted,
    setSubmitted,
    validated,
    setValidated,
    errors,
    resetForm,
  } = useForm(attemptAccountUpdate, user);

  const clearFormComponent = () => {
    const formComponent = document.getElementById('acct-profile-form');
    formComponent.reset();
  };

  const submitWrapper = (e) => {
    if (isEqual(user, data) || disableForm) {
      e.preventDefault();
      e.stopPropagation();
    } else {
      handleSubmit(e);
    }
  };

  useEffect(() => {
    if (validated && submitted) {
      setDisableForm(true);
      setTimeout(() => {
        setValidated(false);
        setSubmitted(false);
        setDisableForm(false);
      }, 3000);
    }
  }, [submitted, validated]);

  return user ? (
    <>
      <Form
        id="acct-profile-form"
        className="p-4"
        noValidate
        validated={validated}
        onSubmit={submitWrapper}
        style={{ background: 'white' }}
      >
        <h4>My Info</h4>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={4}>
            <Form.Group controlId="formFirstName">
              <Form.Label>First Name</Form.Label>
              <Form.Control
                value={data.first_name ?? ''}
                placeholder="Enter first name here"
                onChange={(e) => {
                  handleChange('first_name', e.target.value);
                }}
                isInvalid={!!errors.firstName}
              />
              <Form.Control.Feedback type="invalid">
                {!data.first_name
                  ? 'Please provide a first name.'
                  : errors.firstName}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formLastName">
              <Form.Label>Last Name</Form.Label>
              <Form.Control
                value={data.last_name ?? ''}
                placeholder="Enter last name here"
                onChange={(e) => {
                  handleChange('last_name', e.target.value);
                }}
                isInvalid={!!errors.lastName}
              />
              <Form.Control.Feedback type="invalid">
                {!data.last_name
                  ? 'Please provide a last name.'
                  : errors.lastName}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="pl-lg-5">
            <label className="text-muted">Show on Profile</label>
            <Form.Switch
              id="show-on-profile-name-switch"
              className="custom-switch-md"
              checked={data.show_name}
              onChange={(e) => {
                handleChange('show_name', e.target.checked);
                basicPropUpdate({
                  user,
                  key: 'show_name',
                  newVal: e.target.checked,
                  tokenRefreshTime,
                });
              }}
            />
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={8}>
            <Form.Group controlId="formUsername">
              <Form.Label>Username (always shown on Profile)</Form.Label>
              <Form.Control
                type="username"
                value={data.username ?? ''}
                onChange={(e) => {
                  handleChange('username', e.target.value);
                }}
                isInvalid={!!errors.username || !!errors.foundExistingUser}
                required
              />
              <Form.Control.Feedback type="invalid">
                {!data.username
                  ? 'Username cannot be empty!'
                  : errors.username || errors.foundExistingUser}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={8}>
            <Form.Group controlId="formEmail">
              <Form.Label>E-mail</Form.Label>
              <Form.Control
                type="email"
                value={data.email ?? ''}
                onChange={(e) => {
                  handleChange('email', e.target.value);
                }}
                isInvalid={!!errors.email}
                placeholder="Enter e-mail here"
                readOnly
              />
              <Form.Control.Feedback type="invalid">
                {!data.email
                  ? 'Please provide an e-mail address.'
                  : errors.email}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="align-self-center pl-lg-5">
            <Form.Switch
              id="show-on-profile-email-switch"
              className="custom-switch-md"
              checked={data.show_email}
              onChange={(e) => {
                handleChange('show_email', e.target.checked);
                basicPropUpdate({
                  user,
                  key: 'show_email',
                  newVal: e.target.checked,
                  tokenRefreshTime,
                });
              }}
            />
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={4}>
            <Form.Group controlId="formCity">
              <Form.Label>City</Form.Label>
              <Form.Control
                type="city"
                value={data.city ?? ''}
                onChange={(e) => {
                  handleChange('city', e.target.value);
                }}
                isInvalid={data.city && !!errors.city}
                placeholder="Enter city here"
              />
              <Form.Control.Feedback type="invalid">
                {errors.city}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formState">
              <Form.Label>State</Form.Label>
              <Form.Control
                type="state"
                value={data.state ?? ''}
                onChange={(e) => {
                  handleChange('state', e.target.value);
                }}
                isInvalid={data.state && !!errors.state}
                placeholder="Enter state here"
              />
              <Form.Control.Feedback type="valid">
                {submitted ? 'Profile change successful' : null}
              </Form.Control.Feedback>
              <Form.Control.Feedback type="invalid">
                {errors.state}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="align-self-center pl-lg-5">
            <Form.Switch
              id="show-on-profile-location-switch"
              className="custom-switch-md"
              checked={data.show_location}
              onChange={(e) => {
                handleChange('show_location', e.target.checked);
                basicPropUpdate({
                  user,
                  key: 'show_location',
                  newVal: e.target.checked,
                  tokenRefreshTime,
                });
              }}
            />
          </Col>
        </Row>
        <Row
          className={
            isEqual(new AccountReqBody(user), new AccountReqBody(data))
              ? 'd-none'
              : null
          }
        >
          <Col xs={12} xl={6} className="text-center">
            <Button
              variant="info"
              className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4"
              type="submit"
            >
              Save Changes
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
const mapDispatchToProps = { basicPropUpdate, attemptAccountUpdate };

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
