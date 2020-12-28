import React from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';

function Profile(props) {
  const { user } = props;
  return user ? (
    <>
      {/* <h2>{user.username} / Account</h2> */}
      <Form className="p-4" style={{ background: 'white' }}>
        <h4>Account Info</h4>
        <Form.Group controlId="formName" className="mt-4 mb-4">
          <Form.Label>Name</Form.Label>
          <Form.Control type="name" />
        </Form.Group>
        <Form.Group controlId="formUsername" className="mt-4 mb-4">
          <Form.Label>Username</Form.Label>
          <Form.Control type="username" />
        </Form.Group>
        <Form.Group controlId="formEmail" className="mt-4 mb-4">
          <Form.Label>Email</Form.Label>
          <Form.Control type="email" />
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
  };
};

export default connect(mapStateToProps)(Profile);
