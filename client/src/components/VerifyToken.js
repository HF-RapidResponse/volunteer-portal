import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Link, Redirect } from 'react-router-dom';
import { withCookies } from 'react-cookie';

import LoadingSpinner from './LoadingSpinner';
import { VerifyOTPMaybeLogin } from 'store/user-slice';
import { startLogout } from 'store/user-slice';

function VerifyToken(props) {
  const [loading, setLoading] = useState(false);
  const [hasError, setHasError] = useState(null);
  const [canRedirect, setCanRedirect] = useState();
  const { user, cookies, VerifyOTPMaybeLogin } = props;

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const token_id = params.get('token');
    const otp = params.get('otp');
    const verification_type = params.get('type');

    setLoading(true);

    VerifyOTPMaybeLogin(token_id, otp, cookies, verification_type)
      .then(() => {
        setTimeout(() => {
          setCanRedirect(true);
        }, 3000);
      })
      .catch(() => setHasError(true))
      .finally(() => setLoading(false));
  }, []);

  let verified_item = 'account';
  let redirect_path = '/account/profile';
  const verification_type = 'subscription';
  if (verification_type == 'subscription') {
    verified_item = 'subscription';
    redirect_path = '/initiatives';
  }
  return loading ? (
    <LoadingSpinner />
  ) : hasError ? (
    <div className="mt-5 mb-5 text-center">
      <h2 className="mt-3 mb-3">
        Oops, it looks like this verification link is invalid!
      </h2>
      <p className="mt-3 mb-3">
        Return to the registration page <Link to="/register">here</Link>.
      </p>
    </div>
  ) : canRedirect && !!user || canRedirect && verification_type == 'subscription' ? (
    <Redirect push to={`${redirect_path}`} />
  ) : (
    <>
      <div className="mt-5 mb-5 text-center">
        <h2 className="mt-3 mb-3">Verification Successful</h2>
        <p className="mt-3 mb-3">
          Your {`${verified_item}`} has been verified. You will be redirected in about 3
          seconds. If this does not occur automatically, please click{' '}
          <Link to={`${redirect_path}`}>here</Link>.
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
  VerifyOTPMaybeLogin,
};

export default withCookies(
  connect(mapStateToProps, mapDispatchToProps)(VerifyToken)
);
