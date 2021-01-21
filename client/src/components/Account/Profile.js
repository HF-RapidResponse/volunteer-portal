import React from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';

function Profile(props) {
  const { user } = props;
  return user ? (
    <>
      <Form className="p-4" style={{ background: 'white' }}>
        <h4>My Info</h4>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={8}>
            <Form.Group controlId="formName">
              <Form.Label>Name</Form.Label>
              <Form.Control defaultValue={user.name} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="pl-lg-5">
            <label className="text-muted">Show on Profile</label>
            <Form.Switch
              id="show-on-profile-name-switch"
              className="custom-switch-md"
              defaultChecked
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
              defaultChecked
            />
          </Col>
        </Row>
        <Row className="mt-4 mb-4">
          <Col xs={12} md={4}>
            <Form.Group controlId="formCity">
              <Form.Label>City</Form.Label>
              <Form.Control type="city" defaultValue={user.city} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Group controlId="formState">
              <Form.Label>State</Form.Label>
              <Form.Control type="state" defaultValue={user.state} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4} className="align-self-center pl-lg-5">
            <Form.Switch
              id="show-on-profile-location-switch"
              className="custom-switch-md"
              defaultChecked
              size="lg"
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
  };
};

export default connect(mapStateToProps)(Profile);
