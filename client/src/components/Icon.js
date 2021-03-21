import React from "react";
import PropTypes from "prop-types";
import { library } from "@fortawesome/fontawesome-svg-core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import classNames from "classnames";

import { faCheckCircle as fasCheckCircle } from "@fortawesome/free-solid-svg-icons";

import "./Icon.scss";

library.add(fasCheckCircle);

export function Icon({ marginRight, marginLeft, ...props }) {
  const classes = classNames("components-icon", {
    "margin-right": marginRight,
    "margin-left": marginLeft,
  });

  return <FontAwesomeIcon {...props} className={classes} />;
}

Icon.propTypes = {
  marginRight: PropTypes.bool,
  marginLeft: PropTypes.bool,
  icon: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.arrayOf(PropTypes.string),
  ]).isRequired,
};
