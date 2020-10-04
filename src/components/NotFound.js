import React from 'react';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';

function NotFound(props) {
  return (
    <>
      <h1>404</h1>
      <p>We couldn't find that.</p>
      <Link to={'/'}>
        <Button variant="info" className="wide-btn">
          Home
        </Button>
      </Link>
    </>
  );
}

export default NotFound;
