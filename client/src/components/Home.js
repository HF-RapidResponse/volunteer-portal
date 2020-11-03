import React from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import '../styles/home.scss';
import { Link } from 'react-router-dom';
import HFMLKSquare from '../assets/HF-MLK-square.png';

/**
 * Component that displays that landing page.
 */
function Home() {
  document.title = 'HF Volunteer Portal';
  return (
    <>
      <Container className="top-light-shadow">
        <h1 className="header-2 center-when-small">
          It's time to make UBI a reality.
        </h1>
        <Row>
          <Col lg={12} xl={4}>
            <div className="center-when-small">
              <img
                src="https://via.placeholder.com/347x264.png"
                alt="placeholder-home"
              />
            </div>
          </Col>
          <Col lg={12} xl={6} id="top-card-txt">
            <p>
              The UBI initiative means getting money where it is needed the most
              - the hands of the American people. Families all across the United
              States are struggling to sustain themselves throughout the
              coronavirus pandemic, as well as the ever changing and challenging
              environment of the 21st century economy. The best way to insure
              that no American is left behind is to entrust them with a monthly
              dividend to be used as they see fit. Whether it is car repairs,
              medical bills, rent, or the beginning of a new business, UBI will
              help Americans be more confident in their ability to take control
              of their lives and make the American dream their own.
            </p>
          </Col>
        </Row>
      </Container>
      <Container id="bot-group">
        <Col xs={12} lg={9} xl={6} className="shadow-card">
          <h2 className="header-3">What can I do right away?</h2>
          <p>
            Register with Humanity Forward to get started and help manifest our
            goals into reality. Spreading the word to friends and family is a
            great place to begin, so share your excitement with others, and show
            them the ways they themselves can get started volunteering with HF.
          </p>
          <div className="mt-3 mb-3 text-center">
            <Link to="/volunteer">
              <Button
                variant="outline-info"
                style={{ padding: '.35rem 1.5rem' }}
              >
                Register to Volunteer
              </Button>
            </Link>
          </div>
          <p>
            Get involved with our urgent initiatives! Advocate for UBI policy in
            Congress with our Humanity CALLS and Humanity WRITES initiatives, or
            help ensure we can continue fighting for UBI by fundraising.
          </p>
          <div className="text-center mt-4 mb-4">
            <Button variant="outline-info" style={{ padding: '.35rem 1.5rem' }}>
              View Our Initiatives
            </Button>
          </div>
        </Col>
        <Col xs={12} lg={9} xl={6} className="shadow-card">
          <h2 className="header-3">What if I have more time to help?</h2>
          <p>
            If you have the time and ability to contribute to the cause of UBI,
            now is the time to step up to the plate and take initiative! There
            is a lot of work to be done, and every individual can make a
            difference, no matter how much time you have to help. Register with
            Humanity Forward to get started and help manifest our goals into
            reality. Spreading the word to friends and family is a great place
            to begin, so share your excitement with others, and show them the
            ways they themselves can get started volunteering with HF.
          </p>
          <div className="text-center mt-4 mb-4">
            <Link to="/roles">
              <Button
                variant="outline-info"
                style={{ padding: '.35rem 1.5rem' }}
              >
                Browse Volunteer Roles
              </Button>
            </Link>
          </div>
        </Col>
        <Col xs={12} lg={9} xl={6} className="shadow-card">
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
        <div className="text-center">
          <img src={HFMLKSquare} alt="hf-mlk-square" className="mlk-square" />
        </div>
      </Container>
    </>
  );
}

export default Home;
