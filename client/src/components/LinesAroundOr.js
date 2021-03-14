import React from 'react';
import { Container } from 'react-bootstrap';

function LinesAroundOr() {
  return (
    <Container className="align-items-center justify-content-center">
      <p className="horiz-container">
        <span>or</span>
      </p>
      <div className="vert-container">
        <div className="vert-line"></div>
        <p>or</p>
        <div className="vert-line"></div>
      </div>
    </Container>
  );
}

export default LinesAroundOr;
