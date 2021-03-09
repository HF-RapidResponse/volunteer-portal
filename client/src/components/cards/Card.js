import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import "./Card.scss";

export const Card = ({ children, withPadding }) => {
  const classes = classNames("components-cards-card", {
    "with-padding": withPadding,
  });

  return <div className={classes}>{children}</div>;
};

Card.defaultProps = {
  withPadding: true,
};

Card.propTypes = {
  children: PropTypes.node.isRequired,
  withPadding: PropTypes.bool,
};
