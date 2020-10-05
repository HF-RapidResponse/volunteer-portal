import React, { useState } from 'react';
import LoadingSpinner from '../components/LoadingSpinner';

/**
 * Component that displays the calendar page. Currently, we are using an embedded
 * airtable to render the data.
 */
function Calendar() {
  const [loading, setLoading] = useState(true);
  document.title = 'HF Volunteer Portal - Calendar';
  return (
    <>
      <h1>Attend an Event</h1>
      <p>
        We can’t wait for you to join us at an event!
        Select an event for more information, and for registration links.
      </p>
      {loading && <LoadingSpinner />}
      <iframe
        className="airtable-embed"
        src="https://airtable.com/embed/shrGk2bE7oadINvFy?backgroundColor=greenLight&amp;viewControls=on"
        frameBorder="0"
        width="100%"
        height="1000"
        onLoad={() => setLoading(false)}
        title="calendar"
        styles="background: transparent; border: 1px solid #ccc;"
      ></iframe>
    </>
  );
}

export default Calendar;
