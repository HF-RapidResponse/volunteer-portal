import React from 'react';
import { useState, useEffect } from 'react';
import { connect } from 'react-redux';
import { Button, Container, Row, Col, Image } from 'react-bootstrap';
import '../styles/initiatives.scss';
import { Link } from 'react-router-dom';
import LoadingSpinner from './LoadingSpinner';
import { getInitiatives } from '../store/initiative-slice';

/**
 * Component that displays the initiatives page.
 */
function Initiatives(props) {
  const [fetched, setFetched] = useState(false);
  document.title = 'HF Volunteer Portal - Initiatives';
  const { initiatives, getInitiatives } = props;

  useEffect(() => {
    getInitiatives()
      .catch(() => console.error('finally to grab all initiatives'))
      .finally(() => setFetched(true));
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
    const initiative = initiatives[i];
    var button = null;
    if (initiative['roles'].length > 0 || initiative['events'].length > 0) {
      button = (
        <Link to={'/initiatives/' + initiative['initiative_external_id']}>
          <Button variant="info" style={{ padding: '.35rem 1.5rem' }}>
            View Events & Roles
          </Button>
        </Link>
      );
    } else if (initiative['details_url']) {
      button = (
        <a href={initiative['details_url']}>
          <Button variant="info" style={{ padding: '.35rem 1.5rem' }}>
            Learn More
          </Button>
        </a>
      );
    }

    const initKey = initiative['initiative_external_id'];
    cards.push(
      <Container className="mt-5 mb-5">
        {/* <Col
          xs={12}
          lg={9}
          xl={12}
          // className="shadow-card"
          key={initKey}
          className="mt-5 mb-5"
        > */}
        <Row className="initiative-header">
          <div key={initKey + 'header'}>
            <h3 className="p-3 pl-4">Initiative {i + 1}</h3>
          </div>
        </Row>
        <Row className="initiative-content">
          <Col xs={12} lg={8}>
            <div key={initKey + 'content'}>
              <h2 className="header-3-section-breaker">
                {initiative['title']}
              </h2>
              <p>{initiative['content']}</p>
              <div className="text-center mt-4 mb-4">{button}</div>
            </div>
          </Col>
          <Col xs={12} lg={4} className="text-center">
            <Image
              src={'https://via.placeholder.com/300x400'} // initiative.hero_image_url || 'https://via.placeholder.com/300'
              fluid
            />
          </Col>
        </Row>
        {/* <h2 className="header-3-section-lead">Initiative {i + 1}:</h2> */}
        {/* </Col> */}
      </Container>
    );
  }

  return (
    <>
      <h4 key="top-text">
        To get involved in this movement, learn more about Humanity Forward's
        current initiatives down below.
      </h4>
      <Container id="bot-group" key="init-bot-group">
        {/* <Col xs={12} lg={9} xl={6} className="shadow-card">
          <h1 className="header-2">What can I do right away?</h1>
          <p className="bold-subtitle">Want to get involved right away?</p>
          <p>
            Get involved with our urgent initiatives! Advocate for UBI policy in
            Congress with our Humanity CALLS and Humanity WRITES initiatives, or
            help ensure we can continue fighting for UBI by fundraising.
          </p>
        </Col> */}
        {cards}
      </Container>
    </>
  );
}

const mapStateToProps = (state, ownProps) => {
  return {
    initiatives: state.initiativeStore.initiatives,
  };
};
const mapDispatchToProps = { getInitiatives };

export default connect(mapStateToProps, mapDispatchToProps)(Initiatives);
