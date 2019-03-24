import React from "react";
import { Drawer } from "@material-ui/core";

import NavbarList from "./components/navbar-list";

const SideDrawer = () => {
  return (
    <Drawer
      className="desktop-drawer"
      classes={{
        paper: "desktop-drawer"
      }}
      variant="permanent"
      anchor="left"
    >
      <NavbarList />
    </Drawer>
  );
};

export default SideDrawer;
