import React from 'react';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';

function NotFound(props) {
  const quotes = [
    ["I am now convinced that the simplest approach will prove to be the most effective—the solution to poverty is to abolish it directly by a now widely discussed measure: the guaranteed income.", "Dr. Martin Luther King Jr"],
    ["Scarcity will not save us. Abundance will.", "Andrew Yang"],
  ];
  const rand = Math.floor(Math.random() * quotes.length);
  const quote = quotes[rand][0];
  const author = quotes[rand][1];
  
  return (
    <>
      <h1>404</h1>
      <p>We couldn't find what you were looking for, but here's some food for thought:</p>
      <p>"{quote}"</p>
      <p>{author}</p>
      <Link to={'/'}>
        <Button variant="info" className="wide-btn">
          Let's make change!
        </Button>
      </Link>
    </>
  );
}

export default NotFound;
