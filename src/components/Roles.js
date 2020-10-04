import React from 'react';

function Roles(props) {
  return (
    <>
      <h2>Browse HF Volunteer Roles</h2>
      <p>
        Some messages about how there are available positions and roles and jobs
        to fill in. Something else about this, too.
      </p>
      <iframe
        className="airtable-embed"
        src="https://airtable.com/embed/shrZmR6ahgCsyUBGy?backgroundColor=greenLight&viewControls=on"
        frameBorder="0"
        width="100%"
        height="533"
        title="volunteer-listings"
        styles="background: transparent; border: 1px solid #ccc;"
      ></iframe>
    </>
  );
}

export default Roles;
