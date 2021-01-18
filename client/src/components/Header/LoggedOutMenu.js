import React from 'react';
import { Link } from 'react-router-dom';
import { Button } from 'react-bootstrap';

function LoggedOutMenu(props) {
  const { acctLinks, collapse } = props;
  return (
    <>
      <Link to={acctLinks[0].url} className="mt-1 mb-1">
        <Button
          variant="info"
          className="wide-btn ml-3 mr-3"
          style={{ padding: '.4rem 1.8rem' }}
          onClick={collapse}
        >
          {acctLinks[0].displayName}
        </Button>
      </Link>
      <Link to={acctLinks[1].url} className="mt-1 mb-1">
        <Button
          variant="outline-info"
          className="wide-btn ml-3 mr-3"
          style={{ padding: '.4rem 1.8rem' }}
          onClick={collapse}
        >
          {acctLinks[1].displayName}
        </Button>
      </Link>
    </>
  );
}

export default LoggedOutMenu;
