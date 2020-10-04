import React from 'react';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';

function NotFound(props) {
  const quotes = [
    ["I am now convinced that the simplest approach will prove to be the most effective—the solution to poverty is to abolish it directly by a now widely discussed measure: the guaranteed income.", "Dr. Martin Luther King Jr"],
    ["Scarcity will not save us. Abundance will.", "Andrew Yang"],
    ["Taking then the matter up on this ground, the first principle of civilization ought to have been, and still ought to be, that the condition of every person born into the world, after a state of civilization commences, ought not to be worse than if he had been born before that period.", "Thomas Paine"]
  ];
  const rand = Math.floor(Math.random() * quotes.length);
  const quote = quotes[rand][0];
  const author = quotes[rand][1];
  
  return (
    <>
      <h1>404</h1>
      <div style={{maxWidth: "50vw"}}>
      <p>We couldn't find what you were looking for, but here's some food for thought:</p>
      <p class="faint-quote-gray"><i>{quote}</i></p>
      <p class="faint-quote-gray" style={{textAlign: "right"}}>{author}</p>
      </div>
      <Link to={'/'}>
        <Button variant="info" className="wide-btn">
          Forward to the Home Page
        </Button>
      </Link>
    </>
  );
}

export default NotFound;
