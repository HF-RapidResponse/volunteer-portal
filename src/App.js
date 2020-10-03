import React from 'react';
import Header from './components/Header';
import { BrowserRouter } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/base.scss';

function App() {
  return (
    <BrowserRouter>
      <Header />
      <div id="main-content">
        <section>
          <h1 className="hf-black">
            Hello World! This section is black like my soul. We're still on a
            white background.
          </h1>
        </section>
        <section>
          <h2 className="hf-cyan">Here is something in cyan h2!</h2>
        </section>
        <section>
          <h3 className="hf-dark-blue">Here is something in dark blue h3!</h3>
        </section>
        <p>What about p font?</p>
      </div>
    </BrowserRouter>
  );
}

export default App;
