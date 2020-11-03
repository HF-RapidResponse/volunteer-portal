import React from 'react';
import {
  FacebookShareButton,
  TwitterShareButton
} from 'react-share';
import '../styles/recruitmentSocialShare.scss';

function RecruitmentSocialShare() {
  const shareUrl = process.env.REACT_APP_SOCIAL_SHARE_URL;
  const title = 'Volunteer for Hunanity Forward';
  return (
    <div className="text-center">
      <FacebookShareButton 
        url={shareUrl} 
        quote={title} 
        className="btn btn-outline-info mb-3" 
        resetButtonStyle={false}
        aria-label="Share on Facebook">
        Share on Facebook
      </FacebookShareButton>
      <br />
      <TwitterShareButton 
        url={shareUrl} 
        title={title} 
        related={['HumanityForward', 'AndrewYang']} 
        className="btn btn-outline-info" 
        resetButtonStyle={false}
        aria-label="Share on Twitter">
        Share on Twitter
      </TwitterShareButton>
    </div>
  );
}

export default RecruitmentSocialShare;
