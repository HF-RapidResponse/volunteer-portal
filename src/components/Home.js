import React from 'react';
import { Button } from 'react-bootstrap';
import '../styles/home.scss';
import { Link } from 'react-router-dom';

/**
 * Component that displays that landing page.
 */
function Home() {
  document.title = 'HF Volunteer Portal';
  return (
    <>
      <h1>Welcome to the HF Volunteer Portal!</h1>
      <p>
        Humanity Forward is excited you are here! Our volunteers and grassroots
        supporters are the heart of this human-centered movement. We are hard
        at work rewriting the rules of the economy to work for us, the people.
      </p>
      <section>
        <h2>Attend an Event</h2>
        <p>
          There are many opportunities to participate in Humanity Forward events.
          Take a look at our calendar for more information.
        </p>
        <Link to={'/calendar'}>
          <Button variant="info" className="wide-btn">
            View HF Event Calendar
          </Button>
        </Link>
      </section>
      <section>
        <h2>Browse HF Volunteer Roles</h2>
        <p>
          Humanity Forward is looking to grow our volunteer teams, and we have
          many opportunities for you to apply your time, talents and enthusiasm!
          Take a look at our openings for more information.
        </p>
        <Link to={'/roles'}>
          <Button variant="info" className="wide-btn">
            View HF Volunteer Roles
          </Button>
        </Link>
      </section>
    </>
  );
}

export default Home;
