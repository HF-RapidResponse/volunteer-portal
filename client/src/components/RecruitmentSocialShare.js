import React from 'react';
import {
  TwitterShareButton,
  FacebookShareButton,
  RedditShareButton,
  FacebookMessengerShareButton,
  LineShareButton,
  TelegramShareButton,
  ViberShareButton,
  WhatsappShareButton,
  EmailShareButton,

  TwitterIcon,
  FacebookIcon,
  RedditIcon,
  FacebookMessengerIcon,
  LineIcon,
  TelegramIcon,
  ViberIcon,
  WhatsappIcon,
  EmailIcon,
} from 'react-share';
import '../styles/recruitmentSocialShare.scss';

function RecruitmentSocialShare() {
  const shareUrl = process.env.REACT_APP_SOCIAL_SHARE_URL;
  const fbAppId = process.env.REACT_APP_FB_APP_ID;
  const size = 48;
  const title = 'Volunteer for Hunanity Forward';
  const description = 'There are many opportunities to support Humanity Forward and spread the vision of Andrew Yang. Join us!';
  return (
    <div className="recruitment-social-share-buttons">
      <TwitterShareButton url={shareUrl} title={title} related={['HumanityForward', 'AndrewYang']}>
        <TwitterIcon size={size} round />
      </TwitterShareButton>
      <FacebookShareButton url={shareUrl} quote={title}>
        <FacebookIcon size={size} round />
      </FacebookShareButton>
      <RedditShareButton url={shareUrl} title={title}>
        <RedditIcon size={size} round />
      </RedditShareButton>
      <FacebookMessengerShareButton url={shareUrl} appId={fbAppId}>
        <FacebookMessengerIcon size={size} round />
      </FacebookMessengerShareButton>
      <LineShareButton url={shareUrl} title={title}>
        <LineIcon size={size} round />
      </LineShareButton>
      <TelegramShareButton url={shareUrl} title={title}>
        <TelegramIcon size={size} round />
      </TelegramShareButton>
      <ViberShareButton url={shareUrl} title={title}>
        <ViberIcon size={size} round />
      </ViberShareButton>
      <WhatsappShareButton url={shareUrl} title={title}>
        <WhatsappIcon size={size} round />
      </WhatsappShareButton>
      <EmailShareButton url={shareUrl} subject={title} body={description}>
        <EmailIcon size={size} round />
      </EmailShareButton>
    </div>
  );
}

export default RecruitmentSocialShare;
