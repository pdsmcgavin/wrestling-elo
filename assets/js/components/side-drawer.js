import React from "react";
import { Drawer, List } from "@material-ui/core";

import LinkListItem from "./common/link-list-item";
// import PastEventsList from "./past-events-list";

const SideDrawer = () => {
  return (
    <Drawer
      className="drawer"
      classes={{
        paper: "drawer"
      }}
      variant="permanent"
      anchor="left"
    >
      <List>
        <LinkListItem
          text={"Current Wrestlers Elos"}
          route={"/current-wrestlers-elos"}
        />
        <LinkListItem
          text={"All Time Wrestlers Elos"}
          route={"/all-time-wrestlers-elos"}
        />
        <LinkListItem
          text={"Elo Extremes By Year"}
          route={"/elo-extremes-by-year"}
        />
        <LinkListItem
          text={"Wrestler Elo History"}
          route={"/wrestler-elo-history"}
        />
        <LinkListItem
          text={"Match Up Calculator"}
          route={"/match-up-calculator"}
        />
        <LinkListItem text={"Title Contenders"} route={"/title-contenders"} />
        {/* <PastEventsList /> */}
      </List>
    </Drawer>
  );
};

export default SideDrawer;
