import React from "react";
import { List } from "@material-ui/core";
import PropTypes from "prop-types";

import LinkListItem from "./link-list-item";

class NavbarList extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { onClickHandler } = this.props;

    return (
      <List>
        <LinkListItem
          text={"Current Wrestlers Elos"}
          route={"/current-wrestlers-elos"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"All Time Wrestlers Elos"}
          route={"/all-time-wrestlers-elos"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"Elo Extremes By Year"}
          route={"/elo-extremes-by-year"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"Wrestler Elo History"}
          route={"/wrestler-elo-history"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"Match Up Calculator"}
          route={"/match-up-calculator"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"Title Contenders"}
          route={"/title-contenders"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"Past Events"}
          route={"/past-events"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"Upcoming Events"}
          route={"/upcoming-events"}
          onClickHandler={onClickHandler}
        />
        <LinkListItem
          text={"FAQ"}
          route={"/faq"}
          onClickHandler={onClickHandler}
        />
      </List>
    );
  }
}

NavbarList.propTypes = {
  onClickHandler: PropTypes.func
};

export default NavbarList;
