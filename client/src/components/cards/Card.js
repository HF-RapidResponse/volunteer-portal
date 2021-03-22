import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import "./Card.scss";

export const Card = ({ children, withPadding, className }) => {
  const classes = classNames("components-cards-card", className, {
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
  className: PropTypes.string,
};
