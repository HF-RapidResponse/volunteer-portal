import React from 'react';
import { Container, Row, Col } from 'react-bootstrap';
import GoogleOAuthButton from './GoogleOAuthButton';
import GitHubOAuthButton from './GitHubOAuthButton';

function OAuthGroup() {
  return (
    <Container className="text-center">
      <Row>
        <Col xs={12} md={6} xl={12}>
          <GoogleOAuthButton />
        </Col>
        <Col xs={12} md={6} xl={12}>
          <GitHubOAuthButton />
        </Col>
      </Row>
    </Container>
  );
}

export default OAuthGroup;
