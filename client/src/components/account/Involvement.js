import React, { useState, forwardRef } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';

function Involvement(props) {
  const { user } = props;

  const rolesToRender = [];

  if (user) {
    for (let i = 0; i < user.roles.length; i++) {
      const role = user.roles[i];
      rolesToRender.push(
        <Row className="mt-2 mb-2" key={`roles-row-${i}`}>
          <Col xs={10} md={9}>
            <p>{role}</p>
          </Col>
          <Col xs={2} md={3}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              className="bi bi-three-dots-vertical"
              viewBox="0 0 16 16"
            >
              <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z" />
            </svg>
          </Col>
        </Row>
      );
    }
  }
  return user ? (
    <>
      <Form className="p-4" style={{ background: 'white' }}>
        <h4 className="mb-5">Roles</h4>
        <Form.Group controlId="formPassword">{rolesToRender}</Form.Group>
      </Form>
      <Form className="p-4 mt-5 mb-2" style={{ background: 'white' }}>
        <h4 className="mb-5">Initiatives</h4>
        <Row className="mt-2 mb-2">
          <Col xs={12} md={8}>
            <Form.Group controlId="formUsername">
              <Form.Control type="name" defaultValue={user.name} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Switch
              id="organizers-can-see-profile-switch"
              defaultChecked
            />
          </Col>
        </Row>
        <Row className="mt-2 mb-2">
          <Col xs={12} md={8}>
            <Form.Group controlId="formUsername">
              <Form.Control type="name" defaultValue={user.name} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Switch
              id="organizers-can-see-profile-switch"
              defaultChecked
            />
          </Col>
        </Row>
        <Row className="mt-2 mb-2">
          <Col xs={12} md={8}>
            <Form.Group controlId="formUsername">
              <Form.Control type="name" defaultValue={user.name} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Switch
              id="organizers-can-see-profile-switch"
              defaultChecked
            />
          </Col>
        </Row>
        <Row className="mt-2 mb-2">
          <Col xs={12} md={8}>
            <Form.Group controlId="formUsername">
              <Form.Control type="name" defaultValue={user.name} />
            </Form.Group>
          </Col>
          <Col xs={12} md={4}>
            <Form.Switch
              id="organizers-can-see-profile-switch"
              defaultChecked
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

export default connect(mapStateToProps)(Involvement);
