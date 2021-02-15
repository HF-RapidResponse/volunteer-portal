import React from 'react';
import { Nav, NavDropdown } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';

function MainMenu(props) {
  const { mainLinks, collapse } = props;
  const mainLinksToRender = [];

  for (let i = 0; i < mainLinks.length; i++) {
    const link = mainLinks[i];
    if (link.children && link.children.length) {
      const dropdownItems = [];
      for (let j = 0; j < link.children.length; j++) {
        const child = link.children[j];
        dropdownItems.push(
          <NavLink
            className="nav-link ml-5 mr-5"
            to={`/initiatives/${
              child.initiative_external_id || child.external_id
            }`}
            key={`nav-dropdown-child-${j}`}
            onClick={collapse}
          >
            {child.name || child.initiative_name}
          </NavLink>
        );
      }
      dropdownItems.push(
        <NavDropdown.Divider
          key={`nav-dropdown-child-${link.children.length}`}
        />
      );
      dropdownItems.push(
        <NavLink
          className="nav-link ml-5 mr-5"
          to={`${link.url}`}
          key={`nav-dropdown-child-${link.children.length + 1}`}
          onClick={collapse}
        >
          {`See All ${link.displayName.split(' ')[1] || link.displayName}`}
        </NavLink>
      );
      mainLinksToRender.push(
        <NavDropdown title={link.displayName} key={`nav-top-item-${i}`}>
          {dropdownItems}
        </NavDropdown>
      );
    } else {
      mainLinksToRender.push(
        link && link.url[0] === '/' ? (
          <NavLink
            className="nav-link ml-3 mr-3 text-center"
            key={`nav-top-item-${i}`}
            to={link.url}
            onClick={collapse}
          >
            {link.displayName}
          </NavLink>
        ) : (
          <a
            className="nav-link ml-3 mr-3 text-center"
            href={link.url}
            key={`nav-top-item-${i}`}
            onClick={collapse}
          >
            {link.displayName}
          </a>
        )
      );
    }
  }

  return (
    <Nav className="d-lg-flex align-items-center mr-auto">
      {mainLinksToRender}
    </Nav>
  );
}

export default MainMenu;
