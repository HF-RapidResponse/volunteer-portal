import React from "react";
import { Container, Row, Col } from "react-bootstrap";
import { useQuery } from "react-query";

import { Card } from "components/cards/Card";
import LoadingSpinner from "components/LoadingSpinner";
import { Typography } from "components/typography/Typography";
import { CardInitiative } from "components/cards/CardInitiative";

import "./index.scss";

function Initiatives() {
  document.title = "HF Volunteer Portal - Initiatives";

  const { isLoading, error, data } = useQuery("initiatives", () =>
    fetch("/api/initiatives/").then((response) => response.json())
  );

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (error) {
    return (
      <Col xs={12} lg={9}>
        <Card>
          <Typography kind="title-2" className="mb-2" color="blue-humanity">
            Oops
          </Typography>

          <Typography kind="big-copy" className="mb-2" color="gray-4">
            Error loading initiatives
          </Typography>

          <Typography kind="body-standard">Please try again later</Typography>
        </Card>
      </Col>
    );
  }

  const cards = data.map(
    (
      {
        roles_count,
        events_count,
        external_id,
        details_url,
        initiative_name,
        content,
        hero_image_url,
      },
      idx
    ) => {
      let actionHref;
      let actionContent;
      if (roles_count > 0 || events_count > 0) {
        actionHref = `/initiatives/${external_id}`;
        actionContent = "View Events & Roles";
      } else if (details_url) {
        actionHref = details_url;
        actionContent = "Learn More";
      }

      const handleSubmitSubscribe = (values) => {
        // TODO: update when subscribe endpoint is up
        return new Promise((resolve) =>
          setTimeout(() => {
            resolve();
            alert(`Submitted!\n\n${JSON.stringify(values, null, 4)}`);
          }, 500)
        );
      };

      return (
        <Row className="justify-content-center mb-4" key={external_id}>
          <Col xs={12} lg={9}>
            <CardInitiative
              count={idx + 1}
              header={initiative_name}
              description={content}
              imageSrc={hero_image_url}
              actionHref={actionHref}
              actionContent={actionContent}
              onSubmitSubscribe={handleSubmitSubscribe}
            />
          </Col>
        </Row>
      );
    }
  );

  return (
    <Container id="bot-group">
      <Row className="justify-content-center mb-5">
        <Col xs={12} lg={9}>
          <Card>
            <Typography kind="title-3" className="mb-2">
              What can I do right away?
            </Typography>

            <Typography kind="body-bold" className="mb-2" color="gray-4">
              Get involved with our urgent initiatives!
            </Typography>

            <Typography kind="body-standard">
              Advocate for UBI policy in Congress with our Humanity CALLS and
              Humanity WRITES initiatives, or help ensure we can continue
              fighting for UBI by fundraising.
            </Typography>
          </Card>
        </Col>
      </Row>

      {cards}
    </Container>
  );
}

export default Initiatives;
