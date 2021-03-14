import React, { useEffect, useState } from 'react';
import LoadingSpinner from './LoadingSpinner';
import { Button, Col } from 'react-bootstrap';
import { Card } from 'components/cards/Card';
import '../styles/roles.scss';

import '../styles/bootstrap-overrides.scss';

/**
 * Component that displays the vounteer roles page. Currently, we are using an embedded
 * airtable to render the data.
 */
function Roles() {
  const [roles, setRoles] = useState(null);
  const [fetched, setFetched] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    document.title = 'HF Volunteer Portal - Volunteer Openings';
    fetch('/api/volunteer_roles/')
      .then((response) => {
        if (response.ok) {
          response.json().then((data) => {
            setRoles(data);
          });
        } else {
          console.error(response);
        }
        setFetched(true);
      })
      .catch((err) => {
        console.error(err);
        setFetched(true);
      });
  }, []);

  // Show a loading spinner until the page gets a response
  if (!fetched) {
    return <LoadingSpinner />;
  }

  // Show an error message if the page has gotten a response but no roles
  if (!roles) {
    return (
      <Col
        xs={12}
        lg={9}
        xl={6}
        className="shadow-card"
        key="initiatives_special_failed"
      >
        <h2 className="header-3-section-lead">Oops:</h2>
        <h2 className="header-3-section-breaker">Error loading initiatives.</h2>
        <p>Please try again later.</p>
      </Col>
    );
  }

  // Build 'em if you got 'em
  const roleCards = roles.map((role) => _roleCard(role));

  // Return view with role cards
  return (
    <>
      <h1>Volunteer Openings</h1>
      <p>
        Humanity Forward has many volunteer opportunities available, and we look
        forward to growing our teams! Please consider applying, and let us know
        if you have any questions!
      </p>
      <div className="role-card-container">
        {roleCards}
      </div>
    </>
  );
}

function _roleCard(role) {
  const content = 
  <div className="card-content">
    <h3>{role.role_name}</h3>
    <p className="role-highlight">
      Priority: {role.priority}
      <br />
      Weekly time commitment: {role.min_time_commitment}-{role.max_time_commitment} hrs
    </p>
    <p className="role-overview">{role.overview}</p>
    <Button href={role.signup_url} variant="card">
      { role.role_type == "Requires Application" ? "Apply" : "Sign Up"}
    </Button>
  </div>;

  return (
    <Card children={content}>
    </Card>
  );
}

export default Roles;
