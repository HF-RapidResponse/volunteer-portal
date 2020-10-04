import React from 'react';
import { mount } from 'enzyme';
import Header from '../components/Header';
import { BrowserRouter } from 'react-router-dom';

describe('header component', () => {
  it('displays the proper html and text on mount', () => {
    const component = mount(
      <BrowserRouter>
        <Header />
      </BrowserRouter>
    );
    expect(component).toBeDefined();

    const aTags = component.find('a');
    expect(aTags).toBeDefined();
    expect(aTags).toHaveLength(4);

    // inspect the first anchor tag
    const firstATag = aTags.at(0);
    expect(firstATag.html()).toBe(
      '<a class="nav-link" href="/"><img src="hfLogo.svg" alt="HF Logo" id="hf-logo"></a>'
    );

    // inspect the second anchor tag
    const secondATag = aTags.at(1);
    expect(secondATag.html()).toBe(
      '<a class="nav-link" href="/calendar">Event Calendar</a>'
    );

    // inspect the third anchor tag
    const thirdATag = aTags.at(2);
    expect(thirdATag.html()).toBe(
      '<a class="nav-link" href="/roles">Volunteer Roles</a>'
    );

    // inspect the third anchor tag
    const fourthATag = aTags.at(3);
    expect(fourthATag.html()).toBe(
      '<a class="nav-link" href="/about">About</a>'
    );
  });
});
