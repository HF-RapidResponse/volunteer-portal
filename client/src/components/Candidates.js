import React, { useState } from 'react';
import LoadingSpinner from '../components/LoadingSpinner';

/**
 * Component that displays the candidates page. Currently, we are using an embedded
 * airtable to render the data.
 */
function Candidates() {
  const [loading, setLoading] = useState(true);
  document.title = 'HF Volunteer Portal - Candidates';
  return (
    <>
      <h1>Our Candidates</h1>
      <p>Support our endorsed candidates for this upcoming election!</p>
      {loading && <LoadingSpinner />}
      <iframe
        className="airtable-embed"
        src="https://airtable.com/embed/shrmkdEXjXXBzpyl6?backgroundColor=green&viewControls=on"
        frameBorder="0"
        width="100%"
        height="1000"
        onLoad={() => setLoading(false)}
        title="candidates"
        styles="background: transparent; border: 1px solid #ccc;"
      ></iframe>
    </>
  );
}

export default Candidates;
