import React from 'react';
import { FacebookShareButton, TwitterShareButton } from 'react-share';

function RecruitmentSocialShare() {
  const shareUrl = process.env.REACT_APP_SOCIAL_SHARE_URL;
  const title = 'Volunteer for Humanity Forward';
  return (
    <>
      <div className="text-center mt-2 mb-3">
        <FacebookShareButton
          url={shareUrl}
          quote={title}
          className="btn btn-outline-info"
          resetButtonStyle={false}
          aria-label="Share on Facebook"
          style={{ padding: '.35rem 1.5rem' }}
        >
          Share on Facebook
        </FacebookShareButton>
      </div>
      <div className="text-center mt-3 mb-2">
        <TwitterShareButton
          url={shareUrl}
          title={title}
          related={['HumanityForward', 'AndrewYang']}
          className="btn btn-outline-info"
          resetButtonStyle={false}
          aria-label="Share on Twitter"
          style={{ padding: '.35rem 1.5rem' }}
        >
          Share on Twitter
        </TwitterShareButton>
      </div>
    </>
  );
}

export default RecruitmentSocialShare;
