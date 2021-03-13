import React from 'react';
import { Col } from 'react-bootstrap';

function LinesAroundOr() {
  return (
    <>
      <p className="horiz-container">
        <span>or</span>
      </p>
      <div className="vert-container">
        <div className="vert-line"></div>
        <p>or</p>
        <div className="vert-line"></div>
      </div>
    </>
  );
}

export default LinesAroundOr;
