import React from 'react';
import { Container } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faFacebookSquare,
  faInstagram,
  faTwitterSquare,
} from '@fortawesome/free-brands-svg-icons';
import '../styles/footer.scss';

function Footer() {
  return (
    <footer id="main-footer" className="text-center">
      <Container>
        <p className="btn-text">
          <Link to="/about" className="btn-text">
            Learn more about HF
          </Link>
        </p>
        <p className="btn-text">
          <Link to="/about" className="btn-text">
            Who We Are
          </Link>
        </p>
        <p className="btn-text">
          <a
            className="btn-text"
            href="https://secure.actblue.com/donate/mhf-main-v2"
          >
            Donate
          </a>
        </p>
        <Container className="text-center">
          <a
            href="https://www.facebook.com/humanity4ward/"
            className="social-icon"
          >
            <FontAwesomeIcon icon={faFacebookSquare} size="lg" />
          </a>
          <a
            href="https://www.instagram.com/humanity_forward/"
            className="social-icon"
          >
            <FontAwesomeIcon icon={faInstagram} size="lg" />
          </a>
          <a href="https://twitter.com/humanityforward" className="social-icon">
            <FontAwesomeIcon icon={faTwitterSquare} size="lg" />
          </a>
        </Container>
        <hr className="footer-hr" />
        <p className="btn-text">Made for volunteers by volunteers.</p>
        <h5 className="btn-text">Join the Vounteer Portal Development Team!</h5>
      </Container>
    </footer>
  );
}

export default Footer;
