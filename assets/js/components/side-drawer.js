import React from "react";
import Drawer from "@material-ui/core/Drawer";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemText from "@material-ui/core/ListItemText";
import PropTypes from "prop-types";
import { Link } from "react-router-dom";

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
        <ListItemLinkShorthand
          text={"Current Wrestlers Elos"}
          route={"/current-wrestlers-elos"}
        />
        <ListItemLinkShorthand
          text={"All Time Wrestlers Elos"}
          route={"/all-time-wrestlers-elos"}
        />
        <ListItemLinkShorthand
          text={"Elo Extremes By Year"}
          route={"/elo-extremes-by-year"}
        />
        <ListItemLinkShorthand
          text={"Wrestler Elo History"}
          route={"/wrestler-elo-history"}
        />
        <ListItemLinkShorthand
          text={"Match Up Calculator"}
          route={"/match-up-calculator"}
        />
        <ListItemLinkShorthand
          text={"Title Contenders"}
          route={"/title-contenders"}
        />
      </List>
    </Drawer>
  );
};

const ListItemLinkShorthand = ({ text, route }) => {
  return (
    <li>
      <ListItem button component={Link} to={route}>
        <ListItemText primary={text} />
      </ListItem>
    </li>
  );
};

ListItemLinkShorthand.propTypes = {
  text: PropTypes.string,
  route: PropTypes.string
};

export default SideDrawer;
