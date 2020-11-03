import React from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import '../styles/home.scss';
import { Link } from 'react-router-dom';
// import HFMLKHoriz from '../assets/HF-MLK-horiz.png';
import UBISquare from '../assets/UBI-square.png';

/**
 * Component that displays that landing page.
 */
function Home() {
  document.title = 'HF Volunteer Portal';
  return (
    <>
      <Container>
        <h1 className="header-2 center-when-small">
          It's time to make UBI a reality.
        </h1>
        <Row>
          <Col lg={12} xl={4}>
            <div className="center-when-small">
              {/* <img
                src="https://via.placeholder.com/347x264.png"
                alt="placeholder-home"
              /> */}
              <img className="UBI-square" src={UBISquare} alt="UBI-square" />
            </div>
          </Col>
          <Col lg={12} xl={6} id="top-card-txt">
            <p>
              Since March, we’ve delivered nearly $10M in cash relief to over
              20,000 American families impacted by the COVID-19 pandemic. After
              seeing firsthand how impactful this cash relief has been for these
              20,000 families, Andrew has decided to launch a national advocacy
              campaign to get cash relief to every American family during this
              crisis. That means we will be essentially re-launching Andrew’s
              presidential campaign — not to elect Andrew as President, but to
              pass universal basic income in Congress. That will require a
              national political operation, media blitz, and paid
              communications. If we are successful, this campaign and everyone
              who is a part of it would be responsible for saving America from a
              second Great Depression and for eradicating poverty.
            </p>
            <p className="text-right">Andrew and the HF Team</p>
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
          <p className="mb-0">
            Our team is working hard to... Insert message about why we need
            funding and what the money will go towards. All contributions are
            welcomed and highly appreciated... Thank you!
          </p>
          <div className="text-center">
            <a
              href="https://secure.actblue.com/donate/mhf-main-v2"
              target="_blank"
              className="btn-cyan"
            >
              Donate
            </a>
          </div>
        </Col>
        <Col xs={12}>
          <h4>
            “I’m now convinced that the simplest approach will prove to be the
            most effective — the solution to poverty is to abolish it directly
            by a now widely discussed measure: the guaranteed income.”
          </h4>
          <br />
          <p className="text-right">
            <i>Martin Luther King Jr.</i>
            <br />
            <i>Where Do We Go From Here: Chaos or Community (1967)</i>
          </p>
          {/* <img src={HFMLKHoriz} alt="hf-mlk-horiz" /> */}
        </Col>
      </Container>
    </>
  );
}

export default Home;
