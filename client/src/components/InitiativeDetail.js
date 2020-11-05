import { useState } from 'react';
import { Button, Container, Row, Col } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import LoadingSpinner from './LoadingSpinner';

/**
 * Component that displays the inintiatives page.
 */
function InitiativeDetail(props) {
  const id = props.match.params.ext_id;
  const [detail, set] = useState({});
  
  if (!detail.loaded)
  {
    fetch('/api/initiatives/' + id)
      .then(response =>
      {
        if (!response.ok)
        {
          console.log("ASASASA");
          set({failed: true});
        }
        else
        {
          response.json().then(data =>
          {
            const resp = data;
            resp.loaded = true;
            set(resp);
          });
        }
      })
      .catch((err) =>
      {
        console.log("COULDNT CONNECT WAAA");
        set({failed: true});
      });
  }

  if (!detail.loaded && !detail.failed)
  {
    return <LoadingSpinner/>;
  }
  
  function makeCards()
  {
    if (detail.failed)
    {
      return (
        <Col xs={12} lg={9} xl={6} className="shadow-card" key={detail["initiative_external_id"]}>
          <h2 className="header-3-section-lead">Oops:</h2>
          <h2 className="header-3-section-breaker">Error loading the initiative.</h2>
        </Col>
      );
    }
    else
    {
      // Build event cards
      const evts = [];
      for (var i = 0; i < detail["events"].length; i++)
      {
        if (i == 0)
        {
          evts.push(<h2 key="evts_header_special" className="header-2" style={{textAlign: 'center'}}>Upcoming Events</h2>);
        }
        const evt = detail["events"][i];
        const dateOpts = { year: 'numeric', month: 'numeric', day: 'numeric' };
        const timeOpts = { formatMatcher: 'basic', dateStyle: undefined, hour: 'numeric', minute: 'numeric' };
        const startDate = new Date(evt["start_datetime"]);
        const startDateStr = startDate.toLocaleDateString(undefined, dateOpts);
        const startTimeStr = new Intl.DateTimeFormat('default', timeOpts).format(startDate);
        console.log(startTimeStr);
        const endDate = new Date(evt["end_datetime"]);
        const endDateStr = endDate.toLocaleDateString(undefined, dateOpts);
        const endTimeStr = new Intl.DateTimeFormat('default', timeOpts).format(endDate);
        const dateElem = (startDateStr == endDateStr ? (
          <>
            <h3 className="sm-copy-blue">Begins at {startTimeStr} on {startDateStr}</h3>
          </>
        ) : (
          <>
            <h3 className="sm-copy-blue">Begins at {startTimeStr}</h3>
            <h3 className="sm-copy-blue">{startDateStr} - {endDateStr}</h3>
          </>
        ));
        evts.push(
          <Col xs={12} lg={9} xl={6} className="shadow-card" key={evt["event_external_id"]}>
            <h2 style={{margin: "0 0"}} className="header-4">{evt["name"]}</h2>
            {dateElem}
            <p style={{margin: '0.4rem 0', textAlign: 'left'}} className="sm-copy">{evt["description"]}</p>
            <div className="text-center mt-4 mb-4">
              <a href={evt["signup_url"]}>
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
      }
      // Build role cards
      const roles = [];
      for (i = 0; i < detail["roles"].length; i++)
      {
        if (i == 0)
        {
          roles.push(<h2 key="roles_header_special" className="header-2" style={{textAlign: 'center'}}>Volunteer Roles</h2>);
        }
        const role = detail["roles"][i];
        roles.push(
          <Col xs={12} lg={9} xl={6} className="shadow-card" key={role["role_external_id"]}>
            <h2 style={{margin: "0 0"}} className="header-4">{role["name"]}</h2>
            <p className="sm-copy">{role["overview"]}</p>
            <div className="text-center mt-4 mb-4">
              <a href={role["signup_url"]}>
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
      }
      return (
        <>
          <Col xs={12} lg={9} xl={6} className="shadow-card" key={detail["initiative_external_id"]}>
            <h2 className="header-3-section-lead">Initiative:</h2>
            <h2 className="header-3-section-breaker">{detail["title"]}</h2>
            <p>{detail["content"]}</p>
          </Col>
          <>{evts}</>
          <>{roles}</>
        </>
      );
    }
  }

  return (
    <>
      {makeCards()}
    </>
  );
}

export default InitiativeDetail;