import React from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';

function Data(props) {
  const { user } = props;
  return user ? (
    <>
      <h2>This is the settings page!</h2>
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

export default connect(mapStateToProps)(Data);
