import React from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';
import { basicPropUpdate, attemptAccountUpdate } from '../../store/user-slice';
import useForm from '../hooks/useForm';

function Profile(props) {
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
    validated,
    setValidated,
    errors,
    resetForm,
  } = useForm(attemptAccountUpdate, user);
  const clearFormComponent = () => {
    const formComponent = document.getElementById('acct-profile-form');
    formComponent.reset();
  };

  const handleSubmitResponse = (e) => {
    handleSubmit(e);
    // setValidated(true);
  };

  return user ? (
    <>
      <Form
        id="acct-profile-form"
        className="p-4"
        noValidate
        validated={validated}
        onSubmit={handleSubmitResponse}
        style={{ background: 'white' }}
      >
        <h4>My Info</h4>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={4}>
            <Form.Group controlId="formFirstName">
              <Form.Label>First Name</Form.Label>
              <Form.Control
                value={data.first_name ?? user.first_name}
                placeholder="Enter first name here"
                onChange={(e) => {
                  handleChange('first_name', e.target.value);
                }}
                isInvalid={errors.firstName}
              />
              <Form.Control.Feedback type="invalid">
                First name is invalid!
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formLastName">
              <Form.Label>Last Name</Form.Label>
              <Form.Control
                value={data.last_name ?? user.last_name}
                placeholder="Enter last name here"
                onChange={(e) => {
                  handleChange('last_name', e.target.value);
                }}
                isInvalid={errors.lastName}
              />
              <Form.Control.Feedback type="invalid">
                Last name is invalid!
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="pl-lg-5">
            <label className="text-muted">Show on Profile</label>
            <Form.Switch
              id="show-on-profile-name-switch"
              className="custom-switch-md"
              checked={user.show_name}
              onChange={() =>
                basicPropUpdate({
                  user,
                  key: 'show_name',
                  newVal: !user.show_name,
                  tokenRefreshTime,
                })
              }
            />
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={8}>
            <Form.Group controlId="formUsername">
              <Form.Label>Username (always shown on Profile)</Form.Label>
              <Form.Control
                type="username"
                value={data.username ?? user.username}
                onChange={(e) => {
                  handleChange('username', e.target.value);
                }}
                isInvalid={errors.username}
              />
              <Form.Control.Feedback type="invalid">
                Username is invalid!
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={8}>
            <Form.Group controlId="formEmail">
              <Form.Label>Email</Form.Label>
              <Form.Control
                type="email"
                value={data.email ?? user.email}
                onChange={(e) => {
                  handleChange('email', e.target.value);
                }}
                isInvalid={errors.email}
              />
              <Form.Control.Feedback type="invalid">
                Email is invalid!
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="align-self-center pl-lg-5">
            <Form.Switch
              id="show-on-profile-email-switch"
              className="custom-switch-md"
              checked={user.show_email}
              onChange={() =>
                basicPropUpdate({
                  user,
                  key: 'show_email',
                  newVal: !user.show_email,
                  tokenRefreshTime,
                })
              }
            />
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={4}>
            <Form.Group controlId="formCity">
              <Form.Label>City</Form.Label>
              <Form.Control
                type="city"
                // defaultValue={user.city}
                value={data.city ?? user.city}
                onChange={(e) => {
                  handleChange('city', e.target.value);
                }}
                placeholder="Enter city here"
              />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formState">
              <Form.Label>State</Form.Label>
              <Form.Control
                type="state"
                // defaultValue={user.state}
                value={data.state ?? user.state}
                onChange={(e) => {
                  handleChange('state', e.target.value);
                }}
                placeholder="Enter state here"
              />
              <Form.Control.Feedback type="valid">
                {submitted ? 'Profile change successful' : null}
              </Form.Control.Feedback>
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="align-self-center pl-lg-5">
            <Form.Switch
              id="show-on-profile-location-switch"
              className="custom-switch-md"
              checked={user.show_location}
              onChange={() =>
                basicPropUpdate({
                  user,
                  key: 'show_location',
                  newVal: !user.show_location,
                  tokenRefreshTime,
                })
              }
            />
          </Col>
        </Row>
        <Row>
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
