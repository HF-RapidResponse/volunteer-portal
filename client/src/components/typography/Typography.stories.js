import React from "react";

import { Typography } from "components/typography/Typography";

export default {
  title: "Components/Typography",
  component: Typography,
  argTypes: {
    children: { control: "text" },
  },
};

const commonProps = {
  color: "blue-forward",
  children:
    "Climb to the hilltop and tell others behind us what we see. And build a society we want on the other side. The rest of you get up, its time to go. What makes you human. The better world is still possible. Come fight with me.",
};

const Template = (args) => <Typography {...args} />;

export const Jumbo = Template.bind({});
Jumbo.args = {
  kind: "jumbo",
  ...commonProps,
};

export const Title1 = Template.bind({});
Title1.args = {
  kind: "title-1",
  ...commonProps,
};

export const Title2 = Template.bind({});
Title2.args = {
  kind: "title-2",
  ...commonProps,
};

export const BigCopy = Template.bind({});
BigCopy.args = {
  kind: "big-copy",
  ...commonProps,
};

export const Title3 = Template.bind({});
Title3.args = {
  kind: "title-3",
  ...commonProps,
};

export const BodyStandard = Template.bind({});
BodyStandard.args = {
  kind: "body-standard",
  ...commonProps,
};

export const BodyBold = Template.bind({});
BodyBold.args = {
  kind: "body-bold",
  ...commonProps,
};

export const TinyCopy = Template.bind({});
TinyCopy.args = {
  kind: "tiny-copy",
  ...commonProps,
};

export const Caption = Template.bind({});
Caption.args = {
  kind: "caption",
  ...commonProps,
};
