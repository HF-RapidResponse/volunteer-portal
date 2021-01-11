import React, { useState, forwardRef } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import {
  Button,
  Form,
  Container,
  Col,
  Row,
  Image,
  Dropdown,
  DropdownButton,
} from 'react-bootstrap';
import { deleteRole } from '../../store/user-slice';
import VerticalDots from '../VerticalDots';

function Involvement(props) {
  const { user, deleteRole } = props;

  const rolesToRender = [];
  const CustomToggle = forwardRef(({ children, onClick }, ref) => (
    <a
      href=""
      ref={ref}
      style={{ color: 'gray' }}
      onClick={(e) => {
        e.preventDefault();
        onClick(e);
      }}
    >
      {children}
    </a>
  ));

  if (user) {
    for (let i = 0; i < user.roles.length; i++) {
      const role = user.roles[i];
      rolesToRender.push(
        <Row className="mt-2 mb-2" key={`roles-row-${i}`}>
          <Col xs={10} md={9}>
            <p>{role}</p>
          </Col>
          <Col xs={2} md={3}>
            <Dropdown drop="right">
              <Dropdown.Toggle
                as={CustomToggle}
                id="dropdown-custom-components"
              >
                <VerticalDots />
              </Dropdown.Toggle>
              <Dropdown.Menu>
                <Dropdown.Item eventKey="1" onClick={() => deleteRole(role)}>
                  Delete
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
          </Col>
        </Row>
      );
    }
  }
  return user ? (
    <>
      <Form className="p-4" style={{ background: 'white' }}>
        <h4 className="mb-5">Roles</h4>
        {rolesToRender.length ? (
          <Form.Group controlId="formPassword">{rolesToRender}</Form.Group>
        ) : (
          <p className="text-center">You have no roles.</p>
        )}
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

const mapDispatchToProps = { deleteRole };

export default connect(mapStateToProps, mapDispatchToProps)(Involvement);
