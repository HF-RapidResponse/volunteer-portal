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
    fetch('http://localhost:8000/initiatives/' + 'id')
      .then(response =>
      {
        if (!response.ok)
        {
          console.log("ASASASA");
          set({failed: true});
        }
        else
        {
          const resp = response.json();
          resp.loaded = true;
          set(resp);
        }
      })
      .catch((err) =>
      {
        console.log("COULDNT CONNECT WAAA");
        const resp = {"initiative_uuid":"9034760c-92a3-4c8f-8c8e-df2354bc51e9","initiative_external_id":"rec0IfCrd2xURUL7j","name":"Candidate Support","details_url":"www.google.com","title":"Candidate Support","hero_image_url":"https://dl.airtable.com/.attachments/92101c485e80da2898b508df293b43e7/17e16d84/yang_gasworks.jpeg","content":"Supporting endorsed candidates ","roles":[],"events":[{"event_uuid":"0944661c-fc05-4baf-b4f3-e4b0f35da444","event_external_id":"recCGlct2t3OqbBEV","name":"So you want to be a Calling Captain... - 10/31/2020","hero_image_url":"https://dl.airtable.com/.attachments/a76ed2d4f2778a6fd1fa723ebfd4af1a/6b802669/action_network_image","signup_url":"https://www.mobilize.us/humanityforward/event/350958/","details_url":null,"start_datetime":"2020-10-31T20:00:00","end_datetime":"2020-10-31T20:30:00","description":"Do you have an HF-endorsed candidate in your area and want to help?\nDo you enjoy building community and talking about Humanity First policies?\nDo you want to mobilize volunteers and make an impact?\n\nThen this training is for you!\n\nWe'll share our strategy for activating volunteers throughout the movement, hosting successful phone banks, and helping our candidates win their races and get into office.\n\nBring a friend (or two!) and join us for a fun and interactive training.\n\nSee you soon!","point_of_contact":null},{"event_uuid":"0944661c-fc05-4baf-b4f3-e4b0f35da444","event_external_id":"recw8E9t1J2zTnBNM","name":"Humanity CALLS for Thearse McCalmon (NYSD-49) - 10/26/2020","hero_image_url":"https://dl.airtable.com/.attachments/2cc8b32f1d58dc2c93cd839aa145748d/54c6bb80/action_network_image","signup_url":"https://www.mobilize.us/humanityforward/event/347260/","details_url":null,"start_datetime":"2020-10-26T22:00:00","end_datetime":"2020-10-27T00:00:00","description":"Voting is underway across the nation, so let's talk to voters about an incredible candidate, Thearse McCalmon\n\nThearse has taken the Humanity Forward pledge and is ready to move Humanity Forward! Will you fight for her so she can fight for us?\n\n~~~~~\n\n\"Thearse is running for state senate in the city where I was born – Schenectady, NY. Thearse recently ran for mayor of Schenectady and came within dozens of votes of upsetting the incumbent. She is a Mom and former nurse fighting for her community. She won her state senate primary because people realize that she is in their corner. As someone who has experienced homelessness in her life, Thearse understands the importance of creating a human-centered society. Her opponent is a 70 year-old incumbent who is on the wrong side of many issues in Albany.\"\n\n-Andrew Yang","point_of_contact":null}],"highlightedItems":null};
        resp.loaded = true;
        resp.roles = [{role_external_id: "dklgjsdlgkjsdlgj", name: "Humanity Writer", overview: "You will need to do... the stuff!"}];
        set(resp);
        // we're putting sample data here for testing purposes ^
        // but once the API is up and running, this should instead run the line below,
        // letting us know that we failed to connect, and to retry.
        // set({failed: true});
      });
  }

  if (!detail.loaded)
  {
    return <LoadingSpinner/>;
  }
  else
  {
    console.log("ESLINT HAHAAHAHA");
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
              <Link to={'/initiatives/'}>
                <Button
                  variant="outline-info"
                  style={{ padding: '.35rem 1.5rem' }}
                >
                  View Events &amp; Roles
                </Button>
              </Link>
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
              <Link to={'/initiatives/'}>
                <Button
                  variant="outline-info"
                  style={{ padding: '.35rem 1.5rem' }}
                >
                  View Events &amp; Roles
                </Button>
              </Link>
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

  // using dummy data for now
  // const detail = {"initiative_uuid":"9034760c-92a3-4c8f-8c8e-df2354bc51e9","initiative_external_id":"rec0IfCrd2xURUL7j","name":"Candidate Support","details_url":"www.google.com","title":"Candidate Support","hero_image_url":"https://dl.airtable.com/.attachments/92101c485e80da2898b508df293b43e7/17e16d84/yang_gasworks.jpeg","content":"Supporting endorsed candidates ","roles":[],"events":[{"event_uuid":"0944661c-fc05-4baf-b4f3-e4b0f35da444","event_external_id":"recCGlct2t3OqbBEV","name":"So you want to be a Calling Captain... - 10/31/2020","hero_image_url":"https://dl.airtable.com/.attachments/a76ed2d4f2778a6fd1fa723ebfd4af1a/6b802669/action_network_image","signup_url":"https://www.mobilize.us/humanityforward/event/350958/","details_url":null,"start_datetime":"2020-10-31T20:00:00","end_datetime":"2020-10-31T20:30:00","description":"Do you have an HF-endorsed candidate in your area and want to help?\nDo you enjoy building community and talking about Humanity First policies?\nDo you want to mobilize volunteers and make an impact?\n\nThen this training is for you!\n\nWe'll share our strategy for activating volunteers throughout the movement, hosting successful phone banks, and helping our candidates win their races and get into office.\n\nBring a friend (or two!) and join us for a fun and interactive training.\n\nSee you soon!","point_of_contact":null},{"event_uuid":"0944661c-fc05-4baf-b4f3-e4b0f35da444","event_external_id":"recw8E9t1J2zTnBNM","name":"Humanity CALLS for Thearse McCalmon (NYSD-49) - 10/26/2020","hero_image_url":"https://dl.airtable.com/.attachments/2cc8b32f1d58dc2c93cd839aa145748d/54c6bb80/action_network_image","signup_url":"https://www.mobilize.us/humanityforward/event/347260/","details_url":null,"start_datetime":"2020-10-26T22:00:00","end_datetime":"2020-10-27T00:00:00","description":"Voting is underway across the nation, so let's talk to voters about an incredible candidate, Thearse McCalmon\n\nThearse has taken the Humanity Forward pledge and is ready to move Humanity Forward! Will you fight for her so she can fight for us?\n\n~~~~~\n\n\"Thearse is running for state senate in the city where I was born – Schenectady, NY. Thearse recently ran for mayor of Schenectady and came within dozens of votes of upsetting the incumbent. She is a Mom and former nurse fighting for her community. She won her state senate primary because people realize that she is in their corner. As someone who has experienced homelessness in her life, Thearse understands the importance of creating a human-centered society. Her opponent is a 70 year-old incumbent who is on the wrong side of many issues in Albany.\"\n\n-Andrew Yang","point_of_contact":null}],"highlightedItems":null};
  console.log(id);

  return (
    <>
      {makeCards()}
    </>
  );
}

export default InitiativeDetail;