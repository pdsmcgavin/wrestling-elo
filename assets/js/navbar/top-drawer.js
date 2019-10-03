import React from "react";
import { AppBar, Drawer, IconButton, Toolbar } from "@material-ui/core";
import MenuIcon from "@material-ui/icons/Menu";

import NavbarList from "./components/navbar-list";

import "./top-drawer.styl";

class TopDrawer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      drawerTitle: "WWElo",
      open: false
    };

    this.handleDrawerOpenClose = () => {
      this.setState({ open: !this.state.open });
    };

    this.handleListItemClick = () => {
      this.setState({ open: false });
    };
  }

  render() {
    const { open } = this.state;

    return (
      <div className="mobile-drawer">
        <AppBar className="mobile-nav-bar" position="fixed">
          <Toolbar>
            <IconButton
              color="inherit"
              aria-label="Open or close drawer"
              onClick={this.handleDrawerOpenClose}
            >
              <MenuIcon />
            </IconButton>
            <div className="mobile-nav-bar-title">{this.state.drawerTitle}</div>
          </Toolbar>
        </AppBar>
        <Drawer
          className="top-drawer"
          classes={{
            paper: "top-drawer"
          }}
          anchor="top"
          variant="persistent"
          open={open}
        >
          <NavbarList onClickHandler={this.handleListItemClick} />
        </Drawer>
      </div>
    );
  }
}

export default TopDrawer;
