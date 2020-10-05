import React, { useState } from 'react';
import LoadingSpinner from '../components/LoadingSpinner';

/**
 * Component that displays the vounteer roles page. Currently, we are using an embedded
 * airtable to render the data.
 */
function Roles() {
  const [loading, setLoading] = useState(true);
  document.title = 'HF Volunteer Portal - Volunteer Openings';
  return (
    <>
      <h1>Browse HF Volunteer Openings</h1>
      <p>
        Humanity Forward has many volunteer opportunities available, and we look
        forward to growing our teams! Please consider applying, and let us know
        if you have any questions!
      </p>
      {loading && <LoadingSpinner />}
      <iframe
        className="airtable-embed"
        src="https://airtable.com/embed/shrZmR6ahgCsyUBGy?backgroundColor=greenLight&viewControls=on"
        frameBorder="0"
        width="100%"
        height="1000"
        onLoad={() => setLoading(false)}
        title="volunteer-listings"
        styles="background: transparent; border: 1px solid #ccc;"
      ></iframe>
    </>
  );
}

export default Roles;
