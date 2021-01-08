import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';
import useForm from '../hooks/useForm';
import { verifyPassword } from '../../store/user-slice';

function Settings(props) {
  const [submitted, setSubmitted] = useState(false);
  const [validated, setValidated] = useState(false);
  const [currPassValid, setCurrPassValid] = useState(false);
  const [newAndRetypeMatch, setNewAndReypteMatch] = useState(false);
  const { user } = props;

  // const handlePasswords = (oldPass, newPass, retypePass) => {
  //   const verifyPayload = { oldPass, newPass, retypePass };
  //   return verifyPassword(verifyPayload);
  // };

  const handleSubmitResponse = (e) => {
    const userSliceResponse = handleSubmit(e);
    setCurrPassValid(userSliceResponse.currPassValid);
    setNewAndReypteMatch(userSliceResponse.newAndRetypeMatch);
    setValidated(currPassValid && newAndRetypeMatch);
  };

  const { handleChange, handleSubmit } = useForm(verifyPassword);
  //console.log('user in settings?', user);
  return user ? (
    <Form
      className="p-4"
      style={{ background: 'white' }}
      noValidate
      validated={validated}
      onSubmit={(e) => handleSubmitResponse(e)}
    >
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
      <Form.Group>
        <div className="mt-3 mb-5">
          <Form.Label>Change Password</Form.Label>
          <Form.Control
            type="password"
            placeholder="Old Password"
            id="old-pass"
            onChange={(e) => handleChange('oldPass', e.target.value)}
            isValid={currPassValid}
            isInvalid={!newAndRetypeMatch}
            required
          />
          <Form.Control.Feedback type="invalid">
            Password is invalid!
          </Form.Control.Feedback>
        </div>
        <div className="mt-5 mb-2">
          <Form.Label>New Password</Form.Label>
          <Form.Control
            type="password"
            id="new-pass"
            onChange={(e) => handleChange('newPass', e.target.value)}
            isValid={newAndRetypeMatch}
            isInvalid={!newAndRetypeMatch}
            required
          />
        </div>
        <div className="mt-2 mb-2">
          <Form.Label>Retype Password</Form.Label>
          <Form.Control
            type="password"
            id="retype-pass"
            onChange={(e) => handleChange('retypePass', e.target.value)}
            isValid={newAndRetypeMatch}
            isInvalid={!newAndRetypeMatch}
            required
          />
          <Form.Control.Feedback type="invalid">
            Passwords do not match!
          </Form.Control.Feedback>
          <Form.Control.Feedback type="valid">
            Passwords change successful
          </Form.Control.Feedback>
        </div>
      </Form.Group>
      <Row>
        <Col xs={12} xl={6} className="text-center">
          <Button
            variant="info"
            className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4"
            type="submit"
          >
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

// const mapDispatchToProps = { verifyPassword };
export default connect(mapStateToProps)(Settings);
