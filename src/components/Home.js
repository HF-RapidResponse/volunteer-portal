import React from 'react';
import { Button } from 'react-bootstrap';
import '../styles/home.scss';
import { Link } from 'react-router-dom';

function Home(props) {
  return (
    <>
      <h2>Welcome to the HF Volunteer Portal!</h2>
      <p>
        This space is for some motivational text that also explains what this
        dashboard can be used for. Volunteering is fun!
      </p>
      <section>
        <h3>Attend an Event</h3>
        <p>
          Insert a short, one to two sentence blurb about how easy it is to
          attend Humanity Forward events.
        </p>
        <Link to={'/calendar'}>
          <Button variant="info" className="wide-btn">
            View HF Event Calendar
          </Button>
        </Link>
      </section>
      <section>
        <h3>Browse HF Volunteer Roles</h3>
        <p>
          Insert a short, one to two sentence blurb saying that we have
          available roles that need to be filled.
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
