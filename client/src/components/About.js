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
      name: 'Lauren Lau',
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
      <div className="teamlead d-md-flex gap" key={teamLead.name + i}>
        <div className="flex-child">
          <img src={teamLead.portrait} alt={`${teamLead.name} portrait`} />
          <h3>{teamLead.roleName}</h3>
          <h2>{teamLead.name}</h2>
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
      <p style={{ paddingTop: '1rem' }}>
        Message from the HFRR Organizing & Operations Director:
      </p>
      <p>
        Hello Everyone! Welcome to Humanity Forward’s Rapid Response Volunteer Program! This program is designed to centralize the below directives from Andrew Yang and provide volunteer opportunities for supporters to invest skills, intellect and humanity. The work of our volunteers and grassroots has the power to increase public awareness of economic solutions such as Universal Basic Income (UBI) as well as support those most affected by the pandemic.
      </p>
      <p>
        Our main initiatives listed below are not the only areas you can be helpful. The operations of the volunteer program needs help too. Every task, no matter how small, has a significant beneficial effect on the bigger picture of building a more human-centered society.
      </p>
      <p>
        I thank you for being here and look forward to working with you for the future.k
      </p>
      <div className="teamlead d-md-flex justify-content-around gap">
        <div className="text-center">
          <img src={ErickaPortrait} alt="ericka-portrait" />
          <div className="text-center">
            {/* <p style={{ marginTop: '2rem' }} className="med-text"></p> */}
            {/* <h3 style={{ fontSize: '1.2rem' }}> */}
            <h3>Organizing &amp; Operations Director</h3>
            <h2>Ericka McLeod</h2>
          </div>
        </div>
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
      <section className="about-section text-center">
        <p className="med-text thicc">Our Team Leads</p>
        <>{teamLeadProfiles}</>
      </section>
    </>
  );
}

export default About;
