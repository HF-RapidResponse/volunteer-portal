import React, { useState } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';

function Profile(props) {
  const { user } = props;
  return user ? (
    <>
      <h2>This is the profile page!</h2>
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

//   const mapDispatchToProps = { attemptLogin };
export default connect(mapStateToProps)(Profile);
