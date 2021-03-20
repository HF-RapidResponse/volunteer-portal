import React, { useState, useEffect } from 'react';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import LoadingSpinner from './LoadingSpinner';

function LoginCallback(props) {
  const [canRedirect, setCanRedirect] = useState(false);
  const [errorLoading, setErrorLoading] = useState(false);
  const { user, firstAcctPage } = props;

  useEffect(() => {
    setTimeout(() => {
      if (window.location.pathname.includes('/login_callback')) {
        setErrorLoading(true);
      }
    }, 2500);
  }, []);

  useEffect(() => {
    setCanRedirect(!!user);
  }, [user]);

  return errorLoading ? (
    <h2 className="text-center">Error logging in! Please try again later.</h2>
  ) : canRedirect ? (
    <Redirect push to={firstAcctPage || '/account/profile'} />
  ) : (
    <LoadingSpinner />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
    firstAcctPage: state.userStore.firstAcctPage,
  };
};

export default connect(mapStateToProps)(LoginCallback);
