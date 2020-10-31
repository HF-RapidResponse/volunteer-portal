import React from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import '../styles/home.scss';
import { Link } from 'react-router-dom';

/**
 * Component that displays that landing page.
 */
function Home() {
  document.title = 'HF Volunteer Portal';
  return (
    <>
      <Container>
        <h1 className="header-2">It's time to make UBI a reality.</h1>
        <Row>
          <Col lg={12} xl={4}>
            <img
              src="https://via.placeholder.com/347x264.png"
              alt="placeholder-home"
            />
          </Col>
          <Col lg={12} xl={6} id="top-card-txt">
            <p>Lorem ipsum dolor sit amet,</p>
            <p>
              Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
              labore et dolore magna aliqua. Ut enim ad minim veniam, quis
              nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
              consequat. Duis aute irure dolor in reprehenderit in voluptate
              velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
              occaecat cupidatat non proident, sunt in culpa qui officia
              deserunt mollit anim id est laborum.{' '}
            </p>
            <p>Andrew and the HF Team</p>
          </Col>
        </Row>
      </Container>
      <Container id="bot-group">
        <Col xs={12} className="mt-4 mb-4">
          <h2 className="header-3">What can I do right away?</h2>
          <p>
            Eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
            ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
            aliquip ex ea commodo consequat. Duis aute irure dolor in
            reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
            pariatur.
          </p>
          <div className="text-center mt-4 mb-4">
            <Button variant="outline-info">Our Initiatives</Button>
          </div>
        </Col>
        <Col xs={12} className="mt-5 mb-5">
          <h2 className="header-3">What if I have more time to help?</h2>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse
            cillum dolore eu fugiat nulla pariatur. Eiusmod tempor incididunt ut
            labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
            exercitation ullamco laboris nisi ut aliquip ex ea commodo
            consequat.
          </p>
          <div className="text-center">
            <div className="mt-4 mb-4">
              <Link to="/volunteer">
                <Button variant="outline-info">Register to Volunteer</Button>
              </Link>
            </div>
            <div className="mt-4 mb-4">
              <Link to="/roles">
                <Button variant="outline-info">Browse Volunteer Roles</Button>
              </Link>
            </div>
          </div>
        </Col>
        <Col xs={12} className="mt-5 mb-5">
          <p>
            Our team is working hard to... Insert message about why we need
            funding and what the money will go towards. All contributions are
            welcomed and highly appreciated... Thank you!
            <br />
            <div className="text-center">
              <Link to="/donate" className="btn-cyan">
                Donate
              </Link>
            </div>
          </p>
        </Col>
        <Col xs={12}>
          <h4>
            “I’m now convinced that the simplest approach will prove to be the
            most effective — the solution to poverty is to abolish it directly
            by a now widely discussed measure: the guaranteed income.”
          </h4>
          <br />
          <p>
            Martin Luther King Jr. <br />
            Where Do We Go From Here: Chaos or Community (1967)
          </p>
        </Col>
      </Container>
    </>
  );
}

export default Home;
