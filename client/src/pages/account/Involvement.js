import React, { forwardRef } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { Form, Col, Row, Dropdown } from 'react-bootstrap';
import { deleteRole } from '../../store/user-slice';
import VerticalDots from 'components/VerticalDots';
import initiativeSlice from 'store/initiative-slice';
import { toggleInitiativeSubscription } from 'store/user-slice';
import { Identifier } from 'store/user-slice/classes';

function Involvement(props) {
  const {
    user,
    tokenRefreshTime,
    deleteRole,
    initiatives,
    toggleInitiativeSubscription,
  } = props;

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

  let initiativesToRender = [];
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

    // if (user.initiative_map) {
    //   Object.entries(user.initiative_map).forEach(
    //     ([initiative_name, isSubscribed]) => {
    //       initiativesToRender.push(
    //         <Row className="mt-2 mb-2" key={'initiative-' + initiative_name}>
    //           <Col xs={12} md={8}>
    //             <Form.Group>
    //               <Form.Control type="name" value={initiative_name} readOnly />
    //             </Form.Group>
    //           </Col>
    //           <Col xs={12} md={4}>
    //             <Row>
    //               <Col xs={8} sm={7} md={12} className="d-md-none">
    //                 <label className="text-muted ml-lg-5">Subscribed</label>
    //               </Col>
    //               <Col xs={4} sm={5} md={12}>
    //                 <Form.Switch
    //                   id={'involvement-initiative-' + initiative_name}
    //                   className="custom-switch-md ml-lg-5 text-md-center"
    //                   checked={isSubscribed}
    //                   onChange={() =>
    //                     toggleInitiativeSubscription({
    //                       user,
    //                       initiative_name,
    //                       isSubscribed,
    //                       tokenRefreshTime,
    //                     })
    //                   }
    //                 />
    //               </Col>
    //             </Row>
    //           </Col>
    //         </Row>
    //       );
    //     }
    //   );
    // }
    initiativesToRender = initiatives.map(
      ({
        uuid,
        header,
        roles_count,
        events_count,
        external_id,
        details_url,
        initiative_name,
        content,
        hero_image_url,
      }) => {
        return (
          <Row className="mt-2 mb-2" key={'initiative-' + initiative_name}>
            <Col xs={12} md={8}>
              <Form.Group>
                <Form.Control type="name" value={initiative_name} readOnly />
              </Form.Group>
            </Col>
            <Col xs={12} md={4}>
              <Row>
                <Col xs={8} sm={7} md={12} className="d-md-none">
                  <label className="text-muted ml-lg-5">Subscribed</label>
                </Col>
                <Col xs={4} sm={5} md={12}>
                  <Form.Switch
                    id={'involvement-initiative-' + initiative_name}
                    className="custom-switch-md ml-lg-5 text-md-center"
                    checked={!!user.initiative_map[initiative_name]}
                    onChange={() =>
                      toggleInitiativeSubscription({
                        user,
                        uuid,
                        header,
                        initiative_name,
                        isSubscribed: !user.initiative_map[initiative_name],
                        tokenRefreshTime: null,
                      })
                    }
                  />
                </Col>
              </Row>
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
        <Row className="align-items-center">
          <Col xs={12} md={8}>
            <h4 className="mb-4">Initiatives</h4>
          </Col>
          <Col
            xs={12}
            md={4}
            className={
              initiativesToRender.length
                ? 'd-none d-md-block text-center'
                : 'd-none'
            }
          >
            <label className="text-muted ml-lg-5">Subscribed</label>
          </Col>
        </Row>
        {initiativesToRender.length ? (
          <>{initiativesToRender}</>
        ) : (
          <p className="text-center">No initiatives to display</p>
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
    tokenRefreshTime: state.userStore.tokenRefreshTime,
  };
};

const mapDispatchToProps = { deleteRole, toggleInitiativeSubscription };

export default connect(mapStateToProps, mapDispatchToProps)(Involvement);
