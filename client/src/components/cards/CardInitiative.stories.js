import React from "react";

import { CardInitiative } from "components/cards/CardInitiative";

export default {
  title: "Components/CardInitiative",
  component: CardInitiative,
  argTypes: {
    count: { control: "number" },
    header: { control: "text" },
    description: { control: "text" },
  },
};

const commonProps = {
  count: 1,
  header: "Stump Speech",
  description:
    "Thomas Paine was for it at the founding of our country, called it the citizens dividend. Martin Luther King fought for it in the 60s, called it the guaranteed minimum income",
};

const Template = (args) => <CardInitiative {...args} />;

export const Basic = Template.bind({});
Basic.args = {
  ...commonProps,
};

export const WithAction = Template.bind({});
WithAction.args = {
  ...commonProps,
  actionHref: "https://movehumanityforward.com/",
  actionContent: "Click me!!!",
};

export const WithImage = Template.bind({});
WithImage.args = {
  ...commonProps,
  imageSrc: "https://dummyimage.com/842x630",
};

export const WithSubscribe = Template.bind({});
WithSubscribe.args = {
  ...commonProps,
  onSubmitSubscribe: (values) =>
    new Promise((resolve) =>
      setTimeout(() => {
        resolve();
        alert(`Success!\n${JSON.stringify(values, null, 2)}`);
      }, 500)
    ),
};
