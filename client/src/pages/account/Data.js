import React from 'react';
import { Container } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faTools, faRobot } from '@fortawesome/free-solid-svg-icons';

function Data(props) {
  const { user } = props;
  return user ? (
    <Container className="text-center mt-3 mb-3">
      <h2>The data page is currently under construction!</h2>
      <FontAwesomeIcon
        icon={faTools}
        style={{ fontSize: '3rem' }}
        className="m-4"
      />
      <FontAwesomeIcon
        icon={faRobot}
        style={{ fontSize: '3rem' }}
        className="m-4"
      />
    </Container>
  ) : (
    <Redirect push to="/login" />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

export default connect(mapStateToProps)(Data);
