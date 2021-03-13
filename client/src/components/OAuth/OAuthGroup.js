import React from 'react';
import { Col } from 'react-bootstrap';
import GoogleOAuthButton from './GoogleOAuthButton';
import GitHubOAuthButton from './GitHubOAuthButton';

function OAuthGroup() {
  return (
    <>
      <GoogleOAuthButton />
      <GitHubOAuthButton />
    </>
  );
}

export default OAuthGroup;
