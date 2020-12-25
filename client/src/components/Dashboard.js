import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';

function Dashboard(props) {
  const { attemptLogin, user } = props;

  return user ? (
    <>
      <h2>This is the dashboard!</h2>
    </>
  ) : (
    <Redirect push to="/" />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

export default connect(mapStateToProps)(Dashboard);
