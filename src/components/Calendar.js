import React, { useState } from 'react';
import LoadingSpinner from '../components/LoadingSpinner';

/**
 * Component that displays the calendar page. Currently, we are using an embedded
 * airtable to render the data.
 */
function Calendar() {
  const [loading, setLoading] = useState(true);
  return (
    <>
      <h1>Attend an Event</h1>
      <p>
        Message about how we have a lot of exciting HF events, sharing that
        there are different kinds of events to attend, ranging from this to
        that.
      </p>
      {loading && <LoadingSpinner />}
      <iframe
        className="airtable-embed"
        src="https://airtable.com/embed/shrGk2bE7oadINvFy?backgroundColor=greenLight&amp;viewControls=on"
        frameBorder="0"
        width="100%"
        height="533"
        onLoad={() => setLoading(false)}
        title="calendar"
        styles="background: transparent; border: 1px solid #ccc;"
      ></iframe>
    </>
  );
}

export default Calendar;
