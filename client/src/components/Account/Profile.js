import React from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';
import { basicPropUpdate } from '../../store/user-slice';

function Profile(props) {
  const { user, tokenRefreshTime, basicPropUpdate } = props;
  return user ? (
    <>
      <Form className="p-4" style={{ background: 'white' }}>
        <h4>My Info</h4>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={4}>
            <Form.Group controlId="formFirstName">
              <Form.Label>First Name</Form.Label>
              <Form.Control
                defaultValue={user.first_name}
                placeholder="Enter first name here"
              />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formLastName">
              <Form.Label>Last Name</Form.Label>
              <Form.Control
                defaultValue={user.last_name}
                placeholder="Enter last name here"
              />
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
              <Form.Control type="username" defaultValue={user.username} />
            </Form.Group>
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={8}>
            <Form.Group controlId="formEmail">
              <Form.Label>Email</Form.Label>
              <Form.Control type="email" defaultValue={user.email} />
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
                defaultValue={user.city}
                placeholder="Enter city here"
              />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formState">
              <Form.Label>State</Form.Label>
              <Form.Control
                type="state"
                defaultValue={user.state}
                placeholder="Enter state here"
              />
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
const mapDispatchToProps = { basicPropUpdate };

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
