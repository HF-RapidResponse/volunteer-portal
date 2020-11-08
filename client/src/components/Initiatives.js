import React from 'react';
import { useState, useEffect } from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import '../styles/initiatives.scss';
import { Link } from 'react-router-dom';
import LoadingSpinner from './LoadingSpinner';

/**
 * Component that displays the initiatives page.
 */
function Initiatives() {
  const [initiatives, setInitiatives] = useState(null);
  const [fetched, setFetched] = useState(false);
  document.title = 'HF Volunteer Portal - Initiatives';

  useEffect(() => {
    fetch('/api/initiatives')
      .then((response) => {
        if (response.ok) {
          response.json().then((data) => {
            setInitiatives(data);
          });
        } else {
          console.error(response);
        }
        setFetched(true);
      })
      .catch((err) => {
        console.error(err);
        setFetched(true);
      });
  }, []);

  if (!fetched) {
    return <LoadingSpinner />;
  }

  if (!initiatives) {
    return (
      <Col
        xs={12}
        lg={9}
        xl={6}
        className="shadow-card"
        key="initiatives_special_failed"
      >
        <h2 className="header-3-section-lead">Oops:</h2>
        <h2 className="header-3-section-breaker">Error loading initiatives.</h2>
        <p>Please try again later.</p>
      </Col>
    );
  }
  const cards = [];
  for (var i = 0; i < initiatives.length; i++) {
    cards.push(
      <Col
        xs={12}
        lg={9}
        xl={6}
        className="shadow-card"
        key={initiatives[i]['initiative_external_id']}
      >
        <h2 className="header-3-section-lead">Initiative {i + 1}:</h2>
        <h2 className="header-3-section-breaker">{initiatives[i]['title']}</h2>
        <p>{initiatives[i]['content']}</p>
        <div className="text-center mt-4 mb-4">
          <Link to={'/initiatives/' + initiatives[i]['initiative_external_id']}>
            <Button variant="outline-info" style={{ padding: '.35rem 1.5rem' }}>
              View Events &amp; Roles
            </Button>
          </Link>
        </div>
      </Col>
    );
  }

  return (
    <>
      <Container id="bot-group">
        <Col xs={12} lg={9} xl={6} className="shadow-card">
          <h1 className="header-2">What can I do right away?</h1>
          <p className="bold-subtitle">Want to get involved right away?</p>
          <p>
            Get involved with our urgent initiatives! Advocate for UBI policy in
            Congress with our Humanity CALLS and Humanity WRITES initiatives, or
            help ensure we can continue fighting for UBI by fundraising.
          </p>
        </Col>
        <>{cards}</>
      </Container>
    </>
  );
}

export default Initiatives;
