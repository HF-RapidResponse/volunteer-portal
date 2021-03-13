import React from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import GitHubLogo from './GitHubLogo';

function GitHubOAuthButton() {
  return (
    <Button
      variant="outline-secondary"
      className="mt-4 mb-4"
      onClick={() => {
        const baseUrl =
          window.location.port === '8000'
            ? 'http://localhost:8081'
            : window.location.origin;
        const oauthUrl = `${baseUrl}/api/login?provider=github`;
        window.location.href = oauthUrl;
      }}
    >
      <Container>
        <Row>
          <Col style={{ maxWidth: '55px' }}>
            <GitHubLogo />
          </Col>
          <Col>Log in with GitHub</Col>
        </Row>
      </Container>
    </Button>
  );
}

export default GitHubOAuthButton;
