import { useState, useEffect } from 'react';
import { connect } from 'react-redux';
import { Button, Container, Row, Col } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import LoadingSpinner from './LoadingSpinner';
import { getOneInitiative } from '../store/initiative-slice';

/**
 * Component that displays the inintiatives page.
 */
function InitiativeDetail(props) {
  const id = props.match.params.ext_id;
  const [fetched, setFetched] = useState(false);
  const { detailedInitiative, getOneInitiative } = props;
  document.title = 'HF Volunteer Portal - Initiative Details';

  useEffect(() => {
    getOneInitiative(id)
      .catch(() => {
        console.error('failed to retrieve single initiative');
      })
      .finally(() => setFetched(true));
  }, []);

  if (!fetched) {
    return <LoadingSpinner />;
  }

  function makeCards() {
    if (!detailedInitiative) {
      return (
        <Col xs={12} lg={9} xl={6} className="shadow-card">
          <h2 className="header-3-section-lead">Oops:</h2>
          <h2 className="header-3-section-breaker">
            Error loading the initiative.
          </h2>
          <p>Please try again later.</p>
        </Col>
      );
    } else {
      // Build event cards
      const evts = [];
      let currRow = [];
      for (var i = 0; i < detailedInitiative['events'].length; i++) {
        const evt = detailedInitiative['events'][i];
        const dateOpts = { year: 'numeric', month: 'numeric', day: 'numeric' };
        const timeOpts = {
          formatMatcher: 'basic',
          dateStyle: undefined,
          hour: 'numeric',
          minute: 'numeric',
        };
        const startDate = new Date(evt['start_datetime'] + '+0000');
        const startDateStr = startDate.toLocaleDateString(undefined, dateOpts);
        const startTimeStr = new Intl.DateTimeFormat(
          'default',
          timeOpts
        ).format(startDate);
        const endDate = evt['end_datetime']
          ? new Date(evt['end_datetime'] + '+0000')
          : null;
        const endDateStr = endDate
          ? endDate.toLocaleDateString(undefined, dateOpts)
          : null;
        const endTimeStr = endDate
          ? new Intl.DateTimeFormat('default', timeOpts).format(endDate)
          : null; // dunno if we're gonna use this but leaving it here
        const dateElem =
          startDateStr == endDateStr ? (
            <>
              <h3 className="sm-copy-blue">
                Begins at {startTimeStr} on {startDateStr}
              </h3>
            </>
          ) : (
            <>
              <h3 className="sm-copy-blue">Begins at {startTimeStr}</h3>
              <h3 className="sm-copy-blue">
                {startDateStr}
                {endDateStr ? ` - ${endDateStr}` : null}
              </h3>
            </>
          );
        currRow.push(
          <Col
            xs={12}
            md={9}
            lg={7}
            xl={5}
            className="shadow-card"
            key={evt['external_id']}
          >
            <h2 style={{ margin: '0 0' }} className="header-4">
              {evt['name']}
            </h2>
            {dateElem}
            <p
              style={{ margin: '0.4rem 0', textAlign: 'left' }}
              className="sm-copy"
            >
              {evt['description']}
            </p>
            <div className="text-center mt-4 mb-4">
              <a href={evt['signup_url']}>
                <Button
                  variant="outline-info"
                  style={{ padding: '.35rem 1.5rem' }}
                >
                  Sign Up
                </Button>
              </a>
            </div>
          </Col>
        );

        if (i % 2 === 1 || detailedInitiative['events'].length - 1 === i) {
          evts.push(<Row>{currRow}</Row>);
          currRow = [];
        }
      }
      // Build role cards
      const roles = [];
      currRow = [];

      for (let i = 0; i < detailedInitiative['roles'].length; i++) {
        const role = detailedInitiative['roles'][i];
        const button_text =
          role['role_type'] === 'Requires Application'
            ? 'Apply Here'
            : 'Learn More';

        currRow.push(
          <Col
            xs={12}
            md={9}
            lg={7}
            xl={5}
            className="shadow-card"
            key={role['external_id']}
          >
            <h2 style={{ margin: '0 0' }} className="header-4">
              {role['name']}
            </h2>
            <p className="sm-copy">{role['overview']}</p>
            <div className="text-center mt-4 mb-4">
              <a href={role['signup_url'] || role['details_url']}>
                <Button
                  variant="outline-info"
                  style={{ padding: '.35rem 1.5rem' }}
                >
                  {button_text}
                </Button>
              </a>
            </div>
          </Col>
        );

        if (i % 2 === 1 || detailedInitiative['roles'].length - 1 === i) {
          roles.push(<Row key={`role-row-${i}`}>{currRow}</Row>);
          currRow = [];
        }
      }
      var button = null;
      if (detailedInitiative['details_url']) {
        button = (
          <a href={detailedInitiative['details_url']}>
            <Button variant="outline-info" style={{ padding: '.35rem 1.5rem' }}>
              Learn More
            </Button>
          </a>
        );
      }
      return (
        <>
          <Col
            xs={12}
            lg={9}
            xl={6}
            className="shadow-card"
            key={detailedInitiative['initiative_external_id']}
          >
            <h2 className="header-3-section-lead">Initiative:</h2>
            <h2 className="header-3-section-breaker">
              {detailedInitiative['title']}
            </h2>
            <p>{detailedInitiative['content']}</p>
            <div className="text-center mt-4 mb-4">{button}</div>
          </Col>
          {evts.length ? (
            <>
              <h2
                key="evts_header_special"
                className="header-2"
                style={{ textAlign: 'center' }}
              >
                Upcoming Events
              </h2>
              <Container>{evts}</Container>
            </>
          ) : null}
          {roles.length ? (
            <>
              <h2
                key="roles_header_special"
                className="header-2"
                style={{ textAlign: 'center' }}
              >
                Volunteer Roles
              </h2>
              <Container>{roles}</Container>
            </>
          ) : null}
          <Col xs={12} lg={9} xl={6} className="ml-auto mr-auto">
            <Link to="/initiatives" style={{ textDecoration: 'none' }}>
              <Button className="btn-block mt-5 mb-5" variant="info">
                Return to Initiatives
              </Button>
            </Link>
          </Col>
        </>
      );
    }
  }

  return <>{makeCards()}</>;
}

const mapStateToProps = (state) => {
  return {
    detailedInitiative: state.initiativeStore.detailedInitiative,
  };
};

const mapDispatchToProps = { getOneInitiative };

export default connect(mapStateToProps, mapDispatchToProps)(InitiativeDetail);
