import React from 'react';

class Signin extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isSignedIn: false, isLoading: true };
  }

  componentDidMount() {
    this.checkIfSignedIn();
  }

  render() {
    return (
      <>
        <h2>Here is the sign in page!</h2>
        <h3>The standard Lorem Ipsum passage, used since the 1500s</h3>
        {this.state.isLoading ? 
          <>Loading</> : 
          !this.state.isLoading && !this.state.isSignedIn ?
            <a href="/api/login?provider=google">Log in with Google</a> :
            <>You are logged in!</>}
      </>
    );
  }

  checkIfSignedIn() {
    fetch('/api/profile')
      .then(response => this.setState({ isSignedIn: response.status !== 401, isLoading: false }));
  }
}

export default Signin;
