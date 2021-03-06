import React, { useState } from "react";
import { Button, Col } from "react-bootstrap";
import { useQuery } from "react-query";
import moment from "moment";
import _ from "lodash";
import "twix";

import LoadingSpinner from "components/LoadingSpinner";

function Events() {
  const { isLoading, error, data } = useQuery("events", () =>
    fetch("/api/volunteer_events/").then((response) => response.json())
  );

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (error) {
    return (
      <Col xs={12} lg={9} xl={6} className="shadow-card">
        <h2 className="header-3-section-lead">Oops</h2>
        <h2 className="header-3-section-breaker">Error loading events.</h2>
        <p>Please try again later.</p>
      </Col>
    );
  }

  const events = data
    .map(
      ({
        uuid,
        external_id,
        event_name,
        description,
        start_datetime,
        end_datetime,
        signup_url,
      }) => {
        const startDate = moment(`${start_datetime}Z`);
        const endDate = moment(`${end_datetime}Z`);
        const dateRange = moment(startDate).twix(endDate).format();

        if (startDate.isAfter()) {
          return (
            <Col
              xs={12}
              lg={8}
              className="shadow-card"
              key={`${uuid}-${external_id}`}
            >
              <h2 className="header-4">{event_name}</h2>
              <p className="btn-cyan">{dateRange}</p>
              <p>{description}</p>
              <Button variant="info" href={signup_url}>
                Register
              </Button>
            </Col>
          );
        } else {
          return null;
        }
      }
    )
    .filter(Boolean);

  return (
    <div className="mb-5 text-center">
      {_.isEmpty(events) ? (
        <p>No upcoming events. Please check back later!</p>
      ) : (
        events
      )}
    </div>
  );
}

/**
 * Component that displays the calendar page. Currently, we are using an embedded
 * airtable to render the data.
 */
function Calendar() {
  const [loading, setLoading] = useState(true);
  document.title = "HF Volunteer Portal - Calendar";
  return (
    <>
      <h1>Attend an Event</h1>
      <p>
        We can’t wait for you to join us at an event! Select an event for more
        information, and for registration links. If you have&nbsp;
        <a href="https://on.movehumanityforward.com/join_slack">
          joined the HF slack workspace,
        </a>
        &nbsp;be sure to check our #announcements channel for updates and event
        postings.
      </p>
      {loading && <LoadingSpinner />}
      <iframe
        className="airtable-embed mb-4"
        src="https://airtable.com/embed/shrGk2bE7oadINvFy?backgroundColor=greenLight&amp;viewControls=on"
        frameBorder="0"
        width="100%"
        height="1000"
        onLoad={() => setLoading(false)}
        title="calendar"
        styles="background: transparent; border: 1px solid #ccc;"
      />

      <h1 className="text-center mb-5">Upcoming Events</h1>
      <Events />
    </>
  );
}

export default Calendar;
