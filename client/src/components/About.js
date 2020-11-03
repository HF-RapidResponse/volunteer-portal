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
import HFLogoLong from '../assets/HF-horiz-logo.png';
import '../styles/about.scss';

/**
 * Component that renders the about page.
 */
function About() {
  document.title = 'HF Volunteer Portal - About Us';

  const teamLeads = [
    {
      roleName: 'Candidate Support & Congressional Pressure',
      name: 'Tom Jeffrey',
      portrait: TomPortrait,
    },
    {
      roleName: 'COVID Relief Calling Program',
      name: 'Brenna Cully',
      portrait: BrennaPortrait,
    },
    {
      roleName: 'Humanity Hangs',
      name: 'Kimberly Woods',
      portrait: KimberlyPortrait,
    },
    {
      roleName: 'Onboarding',
      name: 'Christina Woo',
      portrait: ChristinaPortrait,
    },
    {
      roleName: 'Email Response',
      name: 'Lauren',
      portrait: LaurenPortrait,
    },
    {
      roleName: 'Data',
      name: 'Tab Dayani',
      portrait: TabPortrait,
    },
    {
      roleName: 'Data',
      name: 'Suzanne Eden',
      portrait: SuzannePortrait,
    },
    {
      roleName: 'Tech',
      name: 'Tucker Tirven',
      portrait: TuckerPortrait,
    },
    {
      roleName: 'Outreach & Chapter Relations',
      name: 'Grey Black',
      portrait: GreyPortrait,
    },
  ];
  const teamLeadProfiles = [];

  for (let i = 0; i < teamLeads.length; i++) {
    const teamLead = teamLeads[i];
    teamLeadProfiles.push(
      <div className="d-md-flex gap" key={teamLead.name + i}>
        <div className="flex-child">
          <h3>{teamLead.roleName}</h3>
          <h2>{teamLead.name}</h2>
        </div>
        <div className="flex-child">
          <img src={teamLead.portrait} alt={`${teamLead.name} portrait`} />
        </div>
      </div>
    );
  }

  return (
    <>
      <div className="text-center">
        <img
          src={HFLogoLong}
          alt="hf-logo-long"
          className="hf-horiz-logo text-center"
        />
        <p className="large-text">Rapid Response Volunteer Program</p>
      </div>
      <hr className="styled-hr" />
      <p className="med-text">Primary Initiatives for Volunteer Involvement</p>
      <div className="bigger-list">
        <ul>
          <li key="candidateSupp">Candidate Support</li>
          <li key="congressPress">Congressional Pressure</li>
          <li key="covidRelief">COVID-19 Relief</li>
        </ul>
      </div>
      <hr className="styled-hr" />
      <div className="d-md-flex justify-content-around gap">
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
        <p style={{ paddingTop: '1rem' }}> Welcome to Humanity Forward Rapid
        Response. I’m excited to work with you to build the UBI movement
        nationwide.  We are going to pressure congress, engage elected officials
        and rally volunteers to make UBI a reality.</p>
        <p>Our movement is growing; Our message is resonating.</p>
        <p>This is bigger than politics; This is about building a human-centered
        society that works for us!</p>
        <section className="about-section text-center"> <p
        className="med-text thicc">Team Leads</p> <>{teamLeadProfiles}</>
      </section>
    </>
  );
}

export default About;
