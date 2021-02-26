import React from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import GoogleLogo from './GoogleLogo';

function GoogleOAuthBtn() {
  return (
    <Button
      variant="dark"
      onClick={() => {
        const baseUrl =
          window.location.port === '8000'
            ? 'http://localhost:8081'
            : window.location.origin;
        const oauthUrl = `${baseUrl}/api/login?provider=google`;
        console.log('What is oauthUrl?', oauthUrl);
        window.location.href = oauthUrl;
      }}
    >
      <Container>
        <Row>
          <Col style={{ maxWidth: '55px' }}>
            <GoogleLogo />
          </Col>
          <Col>Login with Google</Col>
        </Row>
      </Container>
    </Button>
  );
}

export default GoogleOAuthBtn;
