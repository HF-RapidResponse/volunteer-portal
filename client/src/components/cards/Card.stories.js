import React from "react";

import { Card } from "components/cards/Card";

export default {
  title: "Components/Card",
  component: Card,
  argTypes: {
    children: { control: "text" },
  },
};

const commonProps = {
  children:
    "Thomas Paine was for it at the founding of our country, called it the citizens dividend. Martin Luther King fought for it in the 60s, called it the guaranteed minimum income",
};

const Template = (args) => <Card {...args} />;

export const Basic = Template.bind({});
Basic.args = {
  ...commonProps,
};

export const WithoutPadding = Template.bind({});
WithoutPadding.args = {
  ...commonProps,
  withPadding: false,
};
