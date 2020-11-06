import React from 'react';
import ReactDOM from 'react-dom';
import { Button, Container, Row, Col } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import RecruitmentSocialShare from './RecruitmentSocialShare';

function Register() {
  document.title = 'HF Volunteer Portal - Register';
  return (
    <Container>
      <Col xs={12} xl={10} className="top-light-shadow">
        <h1 className="header-2">Become a Humanity Forward volunteer!</h1>
        <p>
          <b>Do you have some more time to spare?</b>
          <br />
          If you have the time and ability to contribute to the cause of UBI,
          now is the time to step up to the plate and take initiative! There is
          a lot of work to be done, and every individual can make a difference,
          no matter how much time you have to help. Register with Humanity
          Forward to get started and help manifest our goals into reality.
          Spreading the word to friends and family is a great place to begin, so
          share your excitement with others, and show them the ways they
          themselves can get started volunteering with HF.
        </p>
      </Col>
      <Col xs={12} lg={9} xl={6} className="shadow-card">
        <h2 className="header-3">Register yourself as a volunteer.</h2>
        <p>
          Let us keep you up to date on what we have in the works.
        </p>
        <div className="text-center">
          <a href="http://on.movehumanityforward.com/volunteer_signup_short">
            <Button variant="outline-info" style={{ padding: '.35rem 1.5rem' }}>
              Register Here
            </Button>
          </a>
        </div>
      </Col>
      <Col xs={12} lg={9} xl={6} className="shadow-card">
        <h2 className="header-3">Tell us more about you.</h2>
        <p>
          We’d love to learn more about you. Please fill out our volunteer
          survey with your interests and talents. This way, we can connect you
          to the volunteer work you find meaningful while you use your greatest
          strengths.
        </p>
        <div className="text-center">
          <a href="https://on.movehumanityforward.com/volunteer_survey">
            <Button variant="outline-info" style={{ padding: '.35rem 1.5rem' }}>
              Go to Survey
            </Button>
          </a>
        </div>
      </Col>
      <Col xs={12} lg={9} xl={6} className="shadow-card">
        <h2 className="header-3">Share this portal with others.</h2>
        <p>
        Give everyone the opportunity to participate in this historic push for UBI.
        The best way to make an impact is to get those around you involved! Every
        drop of water makes the mighty ocean.
        </p>
        <RecruitmentSocialShare />
      </Col>
      <Col xs={12} lg={9} xl={6} className="shadow-card">
        <h2 className="header-3">Receive a personal ActBlue link.</h2>
        <p>
          Want to show off your fundraising talents? Sign up for a Personal
          ActBlue Link, so we can highlight your success in moving Humanity
          Forward!
        </p>
        <div className="form-group" id="donor-link-input-area">
          <input
            type="text"
            className="form-control"
            id="act-blue-email"
            placeholder="Type email address here..."
          />
        </div>
        <p className="sm-copy">
          You’ll get a follow-up email with your personal ActBlue link.
        </p>
        <div className="text-center">
          <Button onClick={SendDonorRequestLink}
            variant="outline-info" style={{ padding: '.35rem 1.5rem' }}>
            Submit Request
          </Button>
        </div>
      </Col>
    </Container>
  );
}

function SendDonorRequestLink() {
  var input = document.getElementById('act-blue-email');
  const email = input.value;
  const invalid_email_message = "Please enter a valid email address.";
  const unknown_error_message = "We're sorry, we are unable to process your request. Our volunteer development team will sort this out as soon as possible";
  if ( !email.includes("@") ) {
    alert(invalid_email_message);
    return;
  }
  const requestOptions = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: email })
  };
  fetch('/api/donation_link_requests/', requestOptions)
    .then((response) => {
      if (response.status >= 200 && response.status <= 299) {
        input.value = "Thank you!";
      } else if (response.status == 422) {
        alert(invalid_email_message);
      } else {
        alert(unknown_error_message);
      }
    }).catch((error) => {
      alert(unknown_error_message);
      console.log(error);
    });
}

export default Register;
