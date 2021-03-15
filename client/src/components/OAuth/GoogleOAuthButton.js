import React from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import GoogleLogo from './GoogleLogo';

function GoogleOAuthButton() {
  return (
    <Button
      variant="outline-primary"
      className="mt-4 mb-4"
      onClick={() => {
        const baseUrl = window.location.origin;
        const oauthUrl = `${baseUrl}/api/login?provider=google`;
        window.location.href = oauthUrl;
      }}
    >
      <Container>
        <Row>
          <Col style={{ maxWidth: '55px' }}>
            <GoogleLogo />
          </Col>
          <Col>Log in with Google</Col>
        </Row>
      </Container>
    </Button>
  );
}

export default GoogleOAuthButton;
