import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSpinner } from '@fortawesome/free-solid-svg-icons';

/**
 * Component that displays while an API fetch function is taking place. Uses Font Awesome to display
 * the magic. Relies on a loading boolean to render.
 */
function LoadingSpinner() {
  return (
    <div style={{ textAlign: 'center' }}>
      <FontAwesomeIcon
        icon={faSpinner}
        spin
        style={{ fontSize: '3rem', margin: '1.5rem auto' }}
      />
    </div>
  );
}

export default LoadingSpinner;
