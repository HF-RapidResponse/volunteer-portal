import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import { withCookies } from 'react-cookie';
import React from "react";
import { BrowserRouter } from "react-router-dom";
import { Provider } from "react-redux";
import { QueryClient, QueryClientProvider } from "react-query";

import Header from "./components/Header";
import PageViewSwitch from "./components/PageViewSwitch";
import Footer from "./components/Footer";
import store from "./store";

import "bootstrap/dist/css/bootstrap.min.css";
import "./styles/base.scss";

const queryClient = new QueryClient();

/**
 * Top level component that renders all other components.
 * Uses React Router DOM to render various pages.
 */
function App(props) {
  const { cookies } = props;
  return (
    <Provider store={store}>
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          <Header />
          <PageViewSwitch />
          <Footer />
        </BrowserRouter>
      </QueryClientProvider>
    </Provider>
  );
}

export default withCookies(App);
