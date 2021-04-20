import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Link, Redirect } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import LoadingSpinner from './LoadingSpinner';
import { getAccountAndSettingsFromHash } from 'store/user-slice';
import { startLogout } from 'store/user-slice';

function VerifyAccount(props) {
  const [loading, setLoading] = useState(false);
  const [hasError, setHasError] = useState(null);
  const [canRedirect, setCanRedirect] = useState();
  const { user, cookies, getAccountAndSettingsFromHash } = props;

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams(window.location.search);
    const hash = params.get('hash');

    getAccountAndSettingsFromHash(hash, cookies)
      .then(() => {
        setTimeout(() => {
          setCanRedirect(true);
        }, 3000);
      })
      .catch(() => setHasError(true))
      .finally(() => {
        setLoading(false);
      });
  }, []);

  return loading ? (
    <LoadingSpinner />
  ) : hasError ? (
    <div className="mt-5 mb-5 text-center">
      <h2 className="mt-3 mb-3">
        Oops, it looks like this account verification link is invalid!
      </h2>
      <p className="mt-3 mb-3">
        Return to the registration page <Link to="/register">here</Link>.
      </p>
    </div>
  ) : canRedirect && !!user ? (
    <Redirect push to="/account/profile" />
  ) : (
    <>
      <div className="mt-5 mb-5 text-center">
        <h2 className="mt-3 mb-3">Account Registered</h2>
        <p className="mt-3 mb-3">
          Your account has been verified. You will be redirected in about 3
          seconds. If this does not occur automatically, please click{' '}
          <Link to="/account/profile">here</Link>.
        </p>
      </div>
    </>
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

const mapDispatchToProps = {
  startLogout,
  getAccountAndSettingsFromHash,
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(VerifyAccount)
);
