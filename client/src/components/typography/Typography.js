import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import "@fontsource/inter/300.css";
import "@fontsource/inter/400.css";
import "@fontsource/inter/500.css";
import "@fontsource/inter/600.css";
import "@fontsource/inter/700.css";

import "./Typography.scss";

const KINDS = {
  jumbo: "h1",
  "title-1": "h1",
  "title-2": "h2",
  "big-copy": "h3",
  "title-3": "h3",
  "body-standard": "p",
  "body-bold": "p",
  "tiny-copy": "p",
  caption: "p",
};

export const Typography = ({
  kind,
  children,
  centerAlign,
  color,
  className,
  inline,
}) => {
  let Component;
  if (inline) {
    Component = "span";
  } else {
    Component = kind ? KINDS[kind] : "p";
  }

  const classes = classNames("component-typography", kind, color, className, {
    "center-align": centerAlign,
  });

  return <Component className={classes}>{children}</Component>;
};

Typography.propTypes = {
  kind: PropTypes.oneOf(Object.keys(KINDS)).isRequired,
  children: PropTypes.node.isRequired,
  centerAlign: PropTypes.bool,
  className: PropTypes.string,
  inline: PropTypes.bool,

  // This should be in-sync with the color names in _variables.scss
  color: PropTypes.oneOf([
    "blue-forward",
    "blue-humanity",
    "blue-button",
    "gray-0",
    "gray-1",
    "gray-2",
    "gray-3",
    "gray-4",
    "gray-5",
    "success",
    "error",
  ]),
};
