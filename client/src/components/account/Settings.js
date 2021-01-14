import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Button, Form, Container, Col, Row, Image } from 'react-bootstrap';
import { withCookies } from 'react-cookie';

import useForm from '../hooks/useForm';
import { verifyPassword, deleteUser } from '../../store/user-slice';

function Settings(props) {
  const [currPassValid, setCurrPassValid] = useState(false);
  const [newAndRetypeMatch, setNewAndReypteMatch] = useState(false);
  const {
    handleChange,
    handleSubmit,
    data,
    setData,
    submitted,
    setSubmitted,
    validated,
    setValidated,
  } = useForm(verifyPassword);
  const { user, deleteUser, cookies } = props;

  const handleSubmitResponse = (e) => {
    const userSliceResponse = handleSubmit(e) || {
      currPassValid: false,
      userSliceResponse: false,
    };
    setCurrPassValid(userSliceResponse.currPassValid);
    setNewAndReypteMatch(userSliceResponse.newAndRetypeMatch);
    setSubmitted(true);
    setValidated(
      userSliceResponse.currPassValid && userSliceResponse.newAndRetypeMatch
    );
  };

  const deletePrompt = () => {
    const userWantsToDelete = confirm(
      'Are you sure you want to delete your account? This cannot be undone.'
    );
    if (userWantsToDelete) {
      cookies.remove('user', { path: '/' });
      deleteUser();
    }
  };

  useEffect(() => {
    if (validated) {
      const formComponent = document.getElementById('acct-settings-form');
      formComponent.reset();
      setData({});
      setSubmitted(false);
      setValidated(false);
      setTimeout(() => {
        setCurrPassValid(false);
        setNewAndReypteMatch(false);
      }, 3000);
    }
  }, [submitted]);
  console.log('what is data.oldPass?', data.oldPass);
  return user ? (
    <Form
      id="acct-settings-form"
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
          <Form.Switch
            id="organizers-can-see-profile-switch"
            className="custom-switch-md"
            defaultChecked
          />
        </Col>
      </Row>
      <Row className="mt-2 mb-2">
        <Col xs={12} md={8}>
          <p>Other volunteers can see my profile</p>
        </Col>
        <Col xs={12} md={4}>
          <Form.Switch
            id="other-vounteers-can-see-profile-switch"
            className="custom-switch-md"
            defaultChecked
          />
        </Col>
      </Row>
      <Form.Group>
        <div className={'mt-3 ' + (data.oldPass ? 'mb-5' : 'mb-4')}>
          <Form.Label>Change Password</Form.Label>
          <Form.Control
            type="password"
            placeholder="Old Password"
            id="old-pass"
            onChange={(e) => handleChange('oldPass', e.target.value)}
            isValid={currPassValid}
            isInvalid={submitted && !currPassValid}
            required
          />
          <Form.Control.Feedback type="invalid">
            Password is invalid!
          </Form.Control.Feedback>
        </div>
        <div className={data.oldPass ? 'mt-5 mb-3' : 'd-none'}>
          <Form.Label>New Password</Form.Label>
          <Form.Control
            type="password"
            id="new-pass"
            onChange={(e) => handleChange('newPass', e.target.value)}
            isValid={newAndRetypeMatch}
            isInvalid={submitted && !newAndRetypeMatch}
            required
          />
        </div>
        <div className={data.oldPass ? 'mt-3 mb-3' : 'd-none'}>
          <Form.Label>Retype Password</Form.Label>
          <Form.Control
            type="password"
            id="retype-pass"
            onChange={(e) => handleChange('retypePass', e.target.value)}
            isValid={newAndRetypeMatch}
            isInvalid={submitted && !newAndRetypeMatch}
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
            Change Password
          </Button>
        </Col>
        <Col xs={12} xl={6} className="text-center">
          <Button
            variant="danger"
            className="mt-4 mb-4 pt-2 pb-2 pr-4 pl-4"
            onClick={() => deletePrompt()}
          >
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

const mapDispatchToProps = { deleteUser };
export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(Settings)
);
