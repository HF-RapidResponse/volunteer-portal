import React from 'react';
import { mount } from 'enzyme';
import Header from '../components/Header';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from '../store/index';

describe('header component', () => {
  it('displays the proper html and text on mount', () => {
    // component needs to be mounted and not rendered or else elements some elements can't be found
    const component = mount(
      <Provider store={store}>
        <BrowserRouter>
          <Header />
        </BrowserRouter>
      </Provider>
    );
    expect(component).toBeDefined();

    const aTags = component.find('a');
    expect(aTags).toBeDefined();
    expect(aTags).toHaveLength(7);

    // inspect the first anchor tag
    const firstATag = aTags.at(0);
    expect(firstATag.html()).toBe(
      '<a aria-current="page" class="nav-link active" href="/"><img src="HF-RR-long-logo.png" alt="HF Logo" id="hf-logo" class="img-fluid"></a>'
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
      '<a class="mt-1 mb-1" href="/register"><button style="padding: .4rem 1.8rem;" type="button" class="wide-btn ml-3 mr-3 btn btn-info">Create an Account</button></a>'
    );

    // inspect the sixth anchor tag
    const seventhATag = aTags.at(6);
    expect(seventhATag.html()).toBe(
      '<a class="mt-1 mb-1" href="/login"><button style="padding: .4rem 1.8rem;" type="button" class="wide-btn ml-3 mr-3 btn btn-outline-info">Log In</button></a>'
    );
  });
});
