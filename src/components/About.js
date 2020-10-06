import React from 'react';
import ErickaPortrait from '../portraits/ericka_portrait.png';
import TomPortrait from '../portraits/tom_portrait.png';
import BrennaPortrait from '../portraits/brenna_portrait.png';
import KimberlyPortrait from '../portraits/kimberly_portrait.png';
import ChristinaPortrait from '../portraits/christina_portrait.png';
import LaurenPortrait from '../portraits/lauren_portrait.png';
import TabPortrait from '../portraits/tab_portrait.png';
import SuzannePortrait from '../portraits/suzanne_portrait.png';
import TuckerPortrait from '../portraits/tucker_portrait.png';
import GreyPortrait from '../portraits/grey_portrait.png';
import '../styles/about.scss';

function About() {
  document.title = 'HF Volunteer Portal - About Us';
  return (
    <>
      <p className="large-text text-center">Rapid Response Volunteer Program</p>
      <hr style={{ margin: '2.5rem auto' }} />
      <p className="med-text">Primary Initiatives for Volunteer Involvement</p>
      <div className="bigger-list">
        <ul>
          <li>Candidate Support</li>
          <li>Congressional Pressure</li>
          <li>COVID-19 Relief</li>
        </ul>
      </div>
      <hr style={{ margin: '2.5rem auto' }} />
      <div class="d-md-flex justify-content-around">
        <div className="text-center">
          <p className="med-text">Organizing &amp; Operations Director</p>
          <br />
          <h3 style={{ fontSize: '1.5rem' }}>
            <i>Ericka McLeod</i>
          </h3>
        </div>
        <div className="text-center">
          <img src={ErickaPortrait} alt="ericka-portrait" />
        </div>
      </div>
      <p style={{ paddingTop: '1rem' }}>
        <i>Hello Everyone!</i> Welcome to Humanity Forward’s Rapid Response
        Volunteer Program! This program is designed to centralize the above
        directives from Andrew Yang and provide volunteer opportunities for
        supporters to invest skills, intellect and humanity. The work of our
        volunteers and grassroots has the power to increase public awareness of
        economic solutions such as Universal Basic Income (UBI) as well as
        support those most affected by the pandemic.
      </p>
      <p>
        Our main initiatives listed above are not the only areas you can be
        helpful. The operations of the volunteer program needs help too. Every
        task, no matter how small, has a significant beneficial effect on the
        bigger picture of building a more human-centered society.
      </p>
      <p>
        I thank you for being here and look forward to working with you for the
        future.
      </p>
      <section className="text-center">
        <p className="med-text thicc gap">Team Leads</p>
        <hr style={{ margin: '2.5rem auto' }} />
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Candidate Support &amp; Congressional Pressure</h3>
            <h2>Tom Jeffrey</h2>
          </div>
          <div className="flex-child">
            <img src={TomPortrait} alt="tom-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>COVID Relief Calling Program</h3>
            <h2>Brenna Cully</h2>
          </div>
          <div className="flex-child">
            <img src={BrennaPortrait} alt="brenna-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Humanity Hangs</h3>
            <h2>Kimblerly Woods</h2>
          </div>
          <div className="flex-child">
            <img src={KimberlyPortrait} alt="kimberly-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Onboarding</h3>
            <h2>Christina Woo</h2>
          </div>
          <div className="flex-child">
            <img src={ChristinaPortrait} alt="christina-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Email Response</h3>
            <h2>Lauren Lau</h2>
          </div>
          <div className="flex-child">
            <img src={LaurenPortrait} alt="lauren-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Data</h3>
            <h2>Tab Dayani</h2>
          </div>
          <div className="flex-child">
            <img src={TabPortrait} alt="tab-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Data</h3>
            <h2>Suzanne Eden</h2>
          </div>
          <div className="flex-child">
            <img src={SuzannePortrait} alt="suzanne-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Tech</h3>
            <h2>Tucker Tirven</h2>
          </div>
          <div className="flex-child">
            <img src={TuckerPortrait} alt="tucker-portrait" />
          </div>
        </div>
        <div className="d-md-flex">
          <div style={{ height: '100%' }} className="flex-child">
            <h3>Outreach &amp; Chapter Relations</h3>
            <h2>Grey Black</h2>
          </div>
          <div className="flex-child">
            <img src={GreyPortrait} alt="grey-portrait" />
          </div>
        </div>
      </section>
    </>
  );
}

export default About;
