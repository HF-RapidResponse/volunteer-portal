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
          <a href="https://movehumanityforward.com/" className="btn-text">
            Learn more about HF
          </a>
        </p>
        <p className="btn-text">
          <Link to="/about" className="btn-text">
            Who We Are
          </Link>
        </p>
        <p className="btn-text">
          <a
            className="btn-text"
            href="https://secure.actblue.com/donate/hf-vol-portal"
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
        <h5 className="btn-text">
          <a
            href="https://docs.google.com/forms/d/e/1FAIpQLSeYVZogpbOYuaawzJQvlHlfdklfUBlrwfhyqeDlkG4g_wXMPg/viewform?usp=sf_link"
            className="btn-text"
          >
            Join the Volunteer Portal Development Team!
          </a>
        </h5>
      </Container>
    </footer>
  );
}

export default Footer;
