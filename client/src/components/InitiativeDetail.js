import { useState, useEffect } from 'react';
import { Button, Container, Row, Col, Card, CardDeck } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import LoadingSpinner from './LoadingSpinner';

/**
 * Component that displays the inintiatives page.
 */
function InitiativeDetail(props) {
  const id = props.match.params.ext_id;
  const [detail, setDetail] = useState(null);
  const [fetched, setFetched] = useState(false);

  // if (!detail.loaded) {
  //   fetch('/api/initiatives/' + id)
  //     .then((response) => {
  //       if (!response.ok) {
  //         // load failed, try reconnect
  //         set({ failed: true });
  //       } else {
  //         response.json().then((data) => {
  //           const resp = data;
  //           resp.loaded = true;
  //           set(resp);
  //         });
  //       }
  //     })
  //     .catch((err) => {
  //       // load failed, try reconnect
  //       set({ failed: true });
  //     });
  // }

  document.title = 'HF Volunteer Portal - Initiative Details';

  useEffect(() => {
    fetch(`/api/initiatives/${id}`)
      .then((response) => {
        if (response.ok) {
          response.json().then((data) => {
            setDetail(data);
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

  function makeCards() {
    if (!detail) {
      return (
        <Col xs={12} lg={9} xl={6} className="shadow-card">
          <h2 className="header-3-section-lead">Oops:</h2>
          <h2 className="header-3-section-breaker">
            Error loading the initiative.
          </h2>
        </Col>
      );
    } else {
      // Build event cards
      const evts = [];
      let currRow;
      for (var i = 0; i < detail['events'].length; i++) {
        const evt = detail['events'][i];
        const dateOpts = { year: 'numeric', month: 'numeric', day: 'numeric' };
        const timeOpts = {
          formatMatcher: 'basic',
          dateStyle: undefined,
          hour: 'numeric',
          minute: 'numeric',
        };
        const startDate = new Date(evt['start_datetime']);
        const startDateStr = startDate.toLocaleDateString(undefined, dateOpts);
        const startTimeStr = new Intl.DateTimeFormat(
          'default',
          timeOpts
        ).format(startDate);
        const endDate = new Date(evt['end_datetime']);
        const endDateStr = endDate.toLocaleDateString(undefined, dateOpts);
        const endTimeStr = new Intl.DateTimeFormat('default', timeOpts).format(
          endDate
        );
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
                {startDateStr} - {endDateStr}
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
            key={evt['event_external_id']}
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

        if (i % 2 === 1) {
          evts.push(<Row>{currRow}</Row>);
          currRow = [];
        }
      }
      // Build role cards
      const roles = [];
      currRow = [];

      for (let i = 0; i < detail['roles'].length; i++) {
        const role = detail['roles'][i];
        if (role['role_type'] == 'Requires Application') {
          currRow.push(
            <Col
              xs={12}
              md={9}
              lg={7}
              xl={5}
              className="shadow-card"
              key={role['role_external_id']}
            >
              <h2 style={{ margin: '0 0' }} className="header-4">
                {role['name']}
              </h2>
              <p className="sm-copy">{role['overview']}</p>
              <div className="text-center mt-4 mb-4">
                <a href={role['signup_url']}>
                  <Button
                    variant="outline-info"
                    style={{ padding: '.35rem 1.5rem' }}
                  >
                    Apply Here
                  </Button>
                </a>
              </div>
            </Col>
          );
        } else {
          currRow.push(
            <Col
              xs={12}
              md={9}
              lg={7}
              xl={5}
              className="shadow-card"
              key={role['role_external_id']}
            >
              <h2 style={{ margin: '0 0' }} className="header-4">
                {role['name']}
              </h2>
              <p className="sm-copy">{role['overview']}</p>
              <div className="text-center mt-4 mb-4">
                <a href={role['details_url']}>
                  <Button
                    variant="outline-info"
                    style={{ padding: '.35rem 1.5rem' }}
                  >
                    Tell me more!
                  </Button>
                </a>
              </div>
            </Col>
          );
        }

        if (i % 2 === 1) {
          roles.push(<Row>{currRow}</Row>);
          currRow = [];
        }
      }
      return (
        <>
          <Col
            xs={12}
            lg={9}
            xl={6}
            className="shadow-card"
            key={detail['initiative_external_id']}
          >
            <h2 className="header-3-section-lead">Initiative:</h2>
            <h2 className="header-3-section-breaker">{detail['title']}</h2>
            <p>{detail['content']}</p>
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

export default InitiativeDetail;
