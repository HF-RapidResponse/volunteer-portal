import React from "react";
import PropTypes from "prop-types";
import { Button, Row, Col, Form, FormControl, Image } from "react-bootstrap";
import { Formik } from "formik";
import * as yup from "yup";

import { Card } from "components/cards/Card";
import { Icon } from "components/Icon";
import { Typography } from "components/typography/Typography";

import "./CardInitiative.scss";
import { colors } from "util/colors";

const VALID_US_ZIPCODE = /(^\d{5}$)|(^\d{5}-\d{4}$)/;

function SubscribeForm({ onSubmit }) {
  const [submission, setSubmission] = React.useState("initial");

  const handleSubmit = (values, actions) => {
    return onSubmit(values, actions)
      .then(() => {
        actions.setSubmitting(false);
        setSubmission("success");
      })
      .catch(() => {
        actions.setSubmitting(false);
        setSubmission("error");
      });
  };

  if (submission === "success") {
    return (
      <>
        <Typography kind="big-copy" className="mb-2">
          Thank you!
        </Typography>

        <Typography kind="body-standard">
          <Icon icon="check-circle" marginRight color={colors.success} />
          Please check your email to confirm your subscription
        </Typography>
      </>
    );
  }

  return (
    <Formik
      initialValues={{ email: "", contactMe: false, zipcode: "" }}
      onSubmit={handleSubmit}
      validationSchema={yup.object({
        email: yup
          .string()
          .email("Please enter a valid email")
          .required("Please enter an email"),
        contactMe: yup.boolean(),
        zipcode: yup.string().when("contactMe", {
          is: true,
          then: yup
            .string()
            .required("Please enter a zip code")
            .matches(VALID_US_ZIPCODE, "Please enter a valid US zip code"),
        }),
      })}
    >
      {({ handleSubmit, handleChange, values, errors, isSubmitting }) => {
        let zipcodeField;
        if (values.contactMe) {
          zipcodeField = (
            <Form.Group>
              <Form.Label>ZIP Code</Form.Label>
              <Form.Control
                type="text"
                name="zipcode"
                placeholder="Enter your zipcode"
                value={values.zipcode}
                onChange={handleChange}
                isInvalid={Boolean(errors.zipcode)}
              />
              <FormControl.Feedback type="invalid">
                {errors.zipcode}
              </FormControl.Feedback>
            </Form.Group>
          );
        }

        return (
          <Form noValidate onSubmit={handleSubmit}>
            <Form.Group>
              <Form.Label>Email</Form.Label>
              <Form.Control
                type="text"
                name="email"
                placeholder="example@email.com"
                value={values.email}
                onChange={handleChange}
                isInvalid={Boolean(errors.email)}
              />
              <FormControl.Feedback type="invalid">
                {errors.email}
              </FormControl.Feedback>
            </Form.Group>

            <Form.Group>
              <Form.Check
                name="contactMe"
                label="Organizers may contact me about this initiative’s volunteer opportunities in my area."
                onChange={handleChange}
                isInvalid={Boolean(errors.contactMe)}
                feedback={errors.terms}
              />
            </Form.Group>

            {zipcodeField}

            <Form.Group>
              <Button
                variant="info"
                type="submit"
                disabled={isSubmitting}
                className="float-right"
              >
                {isSubmitting ? "Subscribing..." : "Subscribe"}
              </Button>
            </Form.Group>
          </Form>
        );
      }}
    </Formik>
  );
}

export function CardInitiative({
  count,
  header,
  description,
  actionHref,
  actionContent,
  imageSrc,
  onSubmitSubscribe,
}) {
  let subscribeCard;
  if (onSubmitSubscribe) {
    subscribeCard = (
      <Card className="mt-4">
        <Row>
          <Col>
            <Typography kind="title-3" className="mb-2">
              Keep me updated
            </Typography>
            <Typography kind="body-standard" className="mb-3">
              Subscribe to stay updated on the progress of this initiative. We
              will not spam nor sell your info.
            </Typography>
          </Col>
          <Col sm={6}>
            <SubscribeForm onSubmit={onSubmitSubscribe} />
          </Col>
        </Row>
      </Card>
    );
  }

  let actionButton;
  if (actionHref && actionContent) {
    actionButton = (
      <Button variant="outline-info" href={actionHref}>
        {actionContent}
      </Button>
    );
  }

  let image;
  if (imageSrc) {
    image = (
      // Hidden only on sm and down
      <Col className="d-none d-md-block">
        <Image src={imageSrc} className="image" fluid />
      </Col>
    );
  }

  return (
    <div className="components-cards-card-initiative">
      <div className="headline">
        <Typography kind="body-bold" color="gray-0">
          Initiative {count}
        </Typography>
      </div>

      <Card>
        <Row>
          <Col md={imageSrc ? 8 : undefined}>
            <Typography kind="big-copy" className="mb-2">
              {header}
            </Typography>
            <Typography kind="body-standard" className="mb-4">
              {description}
            </Typography>
            {actionButton}
          </Col>
          {image}
        </Row>

        {subscribeCard}
      </Card>
    </div>
  );
}

CardInitiative.propTypes = {
  count: PropTypes.number,
  header: PropTypes.string.isRequired,
  description: PropTypes.string.isRequired,
  actionHref: PropTypes.string,
  actionContent: PropTypes.node,
  imageSrc: PropTypes.string,

  // Expects a function that returns a Promise
  onSubmitSubscribe: PropTypes.func,
};
