import React from "react";
import CurrentWrestlerEloTable from "./components/current-wrestler-elo-table";
import WrestlerEloTable from "./components/wrestler-elo-table";
import WrestlerEloByYearTable from "./components/wrestler-elo-by-year-table";
import MatchUpCalculator from "./components/match-up-calculator";
import WrestlerEloHistory from "./components/wrestler-elo-history";
import TitleContenders from "./components/title-contenders";

import Drawer from "@material-ui/core/Drawer";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemText from "@material-ui/core/ListItemText";
import PropTypes from "prop-types";

import { hot } from "react-hot-loader";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { Link, Route, Redirect, Switch } from "react-router-dom";

import "react-select/dist/react-select.css";
import "react-virtualized-select/styles.css";
import "./app.styl";

const client = new ApolloClient({
  link: new HttpLink({ uri: "/api/graphql" }),
  cache: new InMemoryCache()
});

class App extends React.Component {
  render() {
    return (
      <React.Fragment>
        <ApolloProvider client={client}>
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

          <div className="tab-content">
            <Switch>
              <Route
                exact
                path={"/"}
                render={() => (
                  <Redirect replace to={"/current-wrestlers-elos"} />
                )}
              />
              <Route
                path={"/current-wrestlers-elos"}
                component={CurrentWrestlerEloTable}
              />
              <Route
                path={"/all-time-wrestlers-elos"}
                component={WrestlerEloTable}
              />
              <Route
                path={"/elo-extremes-by-year"}
                component={WrestlerEloByYearTable}
              />
              <Route
                path={"/wrestler-elo-history"}
                component={WrestlerEloHistory}
              />
              <Route
                path={"/match-up-calculator"}
                component={MatchUpCalculator}
              />
              <Route path={"/title-contenders"} component={TitleContenders} />
            </Switch>
          </div>
        </ApolloProvider>
      </React.Fragment>
    );
  }
}

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

export default hot(module)(App);
