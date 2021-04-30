import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { withCookies } from 'react-cookie';

import LoadingSpinner from './LoadingSpinner';
import { cancelRegistrationFromhash } from 'store/user-slice/verify-account';
import { startLogout } from 'store/user-slice';

function CancelRegistration(props) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { user, cookies, startLogout } = props;

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams(window.location.search);
    const hash = params.get('hash');

    cancelRegistrationFromhash(hash)
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
      <h2 className="mt-4 mb-4">
        Oops, it looks like this registration cancellation link is invalid!
      </h2>
    </div>
  ) : (
    <>
      <div className="mt-5 mb-5 text-center">
        <h2 className="mt-4 mb-4">Cancel Registration</h2>
        <p className="mt-3 mb-3">
          Your registration has been cancelled. We apologize for any
          inconvenience.
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
  connect(mapStateToProps, mapDispatchToProps)(CancelRegistration)
);
