import React from 'react';
import { Image } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import DataPageComingSoon from 'assets/data-page-coming-soon.png';
import { Card } from 'components/cards/Card';

function Data(props) {
  const { user } = props;
  const children = (
    <>
      <h2>See my data</h2>
      <div className="text-center">
        <Image src={DataPageComingSoon} fluid />
      </div>
      <h4 className="font-weight-light" style={{ color: 'gray' }}>
        We value your data. We won't sell or share any of it, and you'll be able
        to keep track of it here.
      </h4>
    </>
  );

  return user ? (
    <Card children={children} withPadding={true} className="mt-3 mb-3" />
  ) : (
    <Redirect push to="/login" />
  );
}

const mapStateToProps = (state) => {
  return {
    user: state.userStore.user,
  };
};

export default connect(mapStateToProps)(Data);
