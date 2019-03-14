import React from "react";
import { ListItem, ListItemText } from "@material-ui/core";
import PropTypes from "prop-types";
import { Link } from "react-router-dom";

const LinkListItem = ({ text, route }) => {
  return (
    <li>
      <ListItem button component={Link} to={route}>
        <ListItemText primary={text} />
      </ListItem>
    </li>
  );
};

LinkListItem.propTypes = {
  text: PropTypes.string,
  route: PropTypes.string
};

export default LinkListItem;
