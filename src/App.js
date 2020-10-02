import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import './styles/base.scss';

function App() {
  return (
    <BrowserRouter>
      <section>
        <h1 className="hfBlack">
          Hello World! This section is black like my soul. We're still on a
          white background.
        </h1>
      </section>
      <section>
        <h2 className="hfCyan">Here is something in cyan.</h2>
      </section>
      <section>
        <h2 className="hfDarkBlue">Here is something in dark blue.</h2>
      </section>
    </BrowserRouter>
  );
}

export default App;
