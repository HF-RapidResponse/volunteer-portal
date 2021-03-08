import React from 'react';
import '../styles/roles.scss';
import '../styles/bootstrap-overrides.scss';
import {Button} from 'react-bootstrap';

function RoleCard(role) {
  return (
    <div className="role-card">
      <div className="card-content">
        <h3>{role.role_name}</h3>
        <p class="role-highlight">
          Priority: {role.priority}
          <br />
          Weekly time commitment: {role.min_time_commitment}-{role.max_time_commitment} hrs
        </p>
        <p class="role-overview">{role.overview}</p>
        <Button href={role.signup_url} variant="card">
          { role.role_type == "Requires Application" ? "Apply" : "Sign Up"}
        </Button>
      </div>
    </div>
  );
}

export default RoleCard;
