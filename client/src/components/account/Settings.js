import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';

function Settings(props) {
  const { user } = props;
  console.log('user in settings?', user);
  return user ? (
    <Form className="p-4" style={{ background: 'white' }}>
      <h4 className="mb-5">Change Account</h4>
      <Row className="mt-2 mb-2">
        <Col xs={12} md={8}>
          <p>Organizers can see my profile</p>
        </Col>
        <Col xs={12} md={4}>
          <Form.Switch id="organizers-can-see-profile-switch" defaultChecked />
        </Col>
      </Row>
      <Row className="mt-2 mb-2">
        <Col xs={12} md={8}>
          <p>Other volunteers can see my profile</p>
        </Col>
        <Col xs={12} md={4}>
          <Form.Switch
            id="other-vounteers-can-see-profile-switch"
            defaultChecked
          />
        </Col>
      </Row>
      <Form.Group controlId="formPassword">
        <div className="mt-3 mb-5">
          <Form.Label>Change Password</Form.Label>
          <Form.Control type="password" placeholder="Old Password" />
        </div>
        <div className="mt-5 mb-2">
          <Form.Label>New Password</Form.Label>
          <Form.Control type="password" />
        </div>
        <div className="mt-2 mb-2">
          <Form.Label>Retype Password</Form.Label>
          <Form.Control type="password" />
        </div>
      </Form.Group>
      <Row>
        <Col xs={12} xl={6} className="text-center">
          <Button variant="info" className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4">
            Update Password
          </Button>
        </Col>
        <Col xs={12} xl={6} className="text-center">
          <Button variant="danger" className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4">
            Delete my Account
          </Button>
        </Col>
      </Row>
    </Form>
  ) : (
    <Redirect push to="/login" />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

export default connect(mapStateToProps)(Settings);
