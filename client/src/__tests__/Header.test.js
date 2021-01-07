import React from 'react';
import { mount } from 'enzyme';
import Header from '../components/Header';
import { BrowserRouter } from 'react-router-dom';

describe('header component', () => {
  it('displays the proper html and text on mount', () => {
    // component needs to be mounted and not rendered or else elements some elements can't be found
    const component = mount(
      <BrowserRouter>
        <Header />
      </BrowserRouter>
    );
    expect(component).toBeDefined();

    const aTags = component.find('a');
    expect(aTags).toBeDefined();
    expect(aTags).toHaveLength(6);

    // inspect the first anchor tag
    const firstATag = aTags.at(0);
    expect(firstATag.html()).toBe(
      '<a class="nav-link" href="/"><img src="HF-RR-long-logo.png" alt="HF Logo" id="hf-logo"></a>'
    );

    // inspect the second anchor tag
    const secondATag = aTags.at(1);
    expect(secondATag.html()).toBe(
      '<a class="nav-link ml-3 mr-3 text-center" href="/initiatives">Our Initiatives</a>'
    );

    // inspect the third anchor tag
    const thirdATag = aTags.at(2);
    expect(thirdATag.html()).toBe(
      '<a class="nav-link ml-3 mr-3 text-center" href="/calendar">Event Calendar</a>'
    );

    // inspect the fourth anchor tag
    const fourthATag = aTags.at(3);
    expect(fourthATag.html()).toBe(
      '<a class="nav-link ml-3 mr-3 text-center" href="/roles">Volunteer Roles</a>'
    );

    // inspect the fifth anchor tag
    const fifthATag = aTags.at(4);
    expect(fifthATag.html()).toBe(
      '<a class="nav-link ml-3 mr-3 text-center" href="https://movehumanityforward.com/">Return to Parent Site</a>'
    );

    // inspect the sixth anchor tag
    const sixthATag = aTags.at(5);
    expect(sixthATag.html()).toBe(
      '<a href="/register"><button style="padding: .4rem 2.25rem;" type="button" class="wide-btn btn btn-info">Register to Volunteer</button></a>'
    );      
  });
});
