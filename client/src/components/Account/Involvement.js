import React, { forwardRef } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Form, Col, Row, Dropdown } from 'react-bootstrap';
import { deleteRole } from '../../store/user-slice';
import VerticalDots from '../VerticalDots';
import initiativeSlice from '../../store/initiative-slice';
import { toggleInitiativeSubscription } from '../../store/user-slice';

function Involvement(props) {
  const { user, deleteRole, initiatives, toggleInitiativeSubscription } = props;

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

  const initiativesToRender = [];
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

    Object.entries(user.initiative_map).forEach(
      ([initiativeName, isSubscribed]) => {
        initiativesToRender.push(
          <Row className="mt-2 mb-2" key={'initiative-' + initiativeName}>
            <Col xs={12} md={8}>
              <Form.Group>
                <Form.Control type="name" value={initiativeName} readOnly />
              </Form.Group>
            </Col>
            <Col xs={12} md={4}>
              <Form.Switch
                id={'involvement-initiative-' + initiativeName}
                className="custom-switch-md ml-lg-5"
                checked={isSubscribed}
                onChange={() =>
                  toggleInitiativeSubscription({
                    user,
                    initiativeName,
                    isSubscribed,
                  })
                }
              />
            </Col>
          </Row>
        );
      }
    );
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
        <h4 className="mb-4">Initiatives</h4>
        {initiativesToRender.length ? (
          <>
            <Row>
              <Col xs={12} md={8}></Col>
              <Col xs={12} md={4}>
                <label className="text-muted ml-lg-5">Subscribed</label>
              </Col>
            </Row>
            <>{initiativesToRender}</>
          </>
        ) : (
          <p>No initiatives to display</p>
        )}
      </Form>
    </>
  ) : (
    <Redirect push to="/login" />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
    initiatives: state.initiativeStore.initiatives,
  };
};

const mapDispatchToProps = { deleteRole, toggleInitiativeSubscription };

export default connect(mapStateToProps, mapDispatchToProps)(Involvement);
