import React from 'react';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';

function NotFound(props) {
  const quotes = [
    ["I am now convinced that the simplest approach will prove to be the most effective—the solution to poverty is to abolish it directly by a now widely discussed measure: the guaranteed income.", "Dr. Martin Luther King Jr"],
    ["Scarcity will not save us. Abundance will.", "Andrew Yang"],
    ["Taking then the matter up on this ground, the first principle of civilization ought to have been, and still ought to be, that the condition of every person born into the world, after a state of civilization commences, ought not to be worse than if he had been born before that period.", "Thomas Paine"],
    ["If we create enough new companies, there will be additional opportunities for people at every rung of the educational ladder.", "Andrew Yang"],
    ["We always hear about an athlete's humble beginnings—how they emerge from poverty, or tragedy, to beat the odds. They're supposed to be the stories of determination that capture the American Dream. They're supposed to be stories that let you know these people are special. But you know what would be really special? If there were no more humble beginnings.", "LeBron James"],
    ["Now, as a nation, we don't promise equal outcomes, but we were founded on the idea everybody should have an equal opportunity to succeed. No matter who you are, what you look like, where you come from, you can make it. That's an essential promise of America. Where you start should not determine where you end up.", "Barack Obama"]
  ];
  const rand = Math.floor(Math.random() * quotes.length);
  const quote = quotes[rand][0];
  const author = quotes[rand][1];
  
  return (
    <>
      <h1>404</h1>
      <div className="quote-container">
      <p>We couldn't find what you were looking for, but here's some food for thought:</p>
      <p className="faint-quote-gray"><i>{quote}</i></p>
      <p className="faint-quote-gray" style={{textAlign: "right"}}><i>{author}</i></p>
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
