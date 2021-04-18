import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import LoadingSpinner from './LoadingSpinner';
import { getAccountAndSettingsFromHash } from 'store/user-slice/verify-account';
import { startLogout } from 'store/user-slice';

function VerifyAccount(props) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { user, cookies, startLogout } = props;

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams(window.location.search);
    const hash = params.get('hash');

    getAccountAndSettingsFromHash(hash)
      .catch((error) => setError(error))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (user) {
      startLogout(cookies);
    }
  }, [user]);

  return loading ? (
    <LoadingSpinner />
  ) : error ? (
    <div className="mt-5 mb-5 text-center">
      <h2 className="mt-3 mb-3">
        Oops, it looks like this account verification link is invalid!
      </h2>
    </div>
  ) : (
    <>
      <div className="mt-5 mb-5 text-center">
        <h2 className="mt-3 mb-3">Account Registered</h2>
        <p>
          Your account has been verified. You can now{' '}
          <Link to="/login">log in here.</Link>
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
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(VerifyAccount)
);
