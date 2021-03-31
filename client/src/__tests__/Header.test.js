import React from 'react';
import '@testing-library/jest-dom';
import { render, fireEvent, screen } from '@testing-library/react';

import Header from '../components/Header';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from '../store/index';

describe('header component', () => {
  it('displays the proper html and text on mount', () => {
    const component = render(
      <Provider store={store}>
        <BrowserRouter>
          <Header />
        </BrowserRouter>
      </Provider>
    );

    expect(component).toBeDefined();
    const initiativesTag = screen.getByText('Our Initiatives');
    expect(initiativesTag).toBeDefined();

    const eventsTag = screen.getByText('Event Calendar');
    expect(eventsTag).toBeDefined();

    const vounteerTag = screen.getByText('Volunteer Roles');
    expect(vounteerTag).toBeDefined();

    const returnTag = screen.getByText('Return to Parent Site');
    expect(returnTag).toBeDefined();

    const createTag = screen.getByText('Create an Account');
    expect(createTag).toBeDefined();

    const loginTag = screen.getByText('Log In');
    expect(loginTag).toBeDefined();
  });
});
