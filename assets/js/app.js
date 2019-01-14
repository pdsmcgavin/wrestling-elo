import React from "react";
import CurrentWrestlerEloTable from "./components/current-wrestler-elo-table";
import WrestlerEloTable from "./components/wrestler-elo-table";
import WrestlerEloByYearTable from "./components/wrestler-elo-by-year-table";
import WrestlerEloByHeight from "./components/wrestler-elo-by-height";
import WrestlerEloByWeight from "./components/wrestler-elo-by-weight";
import MatchUpCalculator from "./components/match-up-calculator";
import WrestlerEloHistory from "./components/wrestler-elo-history";
import TitleContenders from "./components/title-contenders";

import { hot } from "react-hot-loader";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { Route, Switch, Redirect } from "react-router-dom";
import { NavTab } from "react-router-tabs";

import "react-router-tabs/styles/react-router-tabs.css";
import "react-select/dist/react-select.css";
import "react-virtualized-select/styles.css";
import "../stylus/app.styl";

const client = new ApolloClient({
  link: new HttpLink({ uri: "/api/graphql" }),
  cache: new InMemoryCache()
});

class App extends React.Component {
  render() {
    return (
      <div>
        <h1 className="title">WWElo</h1>
        <ApolloProvider client={client}>
          <div className="tabs">
            <NavTab to="/current-wrestlers-elos">Current Wrestlers Elos</NavTab>
            <NavTab to="/all-time-wrestlers-elos">
              All Time Wrestlers Elos
            </NavTab>
            <NavTab to="/elo-extremes-by-year">Elo Extremes By Year</NavTab>
            <NavTab to="/wrestler-elo-history">Wrestler Elo History</NavTab>
            <NavTab to="/match-up-calculator">Match Up Calculator</NavTab>
            <NavTab to="/elos-by-height">Elos By Height</NavTab>
            <NavTab to="/elos-by-weight">Elos By Weight</NavTab>
            <NavTab to="/title-contenders">Title Contenders</NavTab>
            <div className="fake-tab" />
          </div>
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
              <Route path={"/elos-by-height"} component={WrestlerEloByHeight} />
              <Route path={"/elos-by-weight"} component={WrestlerEloByWeight} />
              <Route path={"/title-contenders"} component={TitleContenders} />
            </Switch>
          </div>
        </ApolloProvider>
      </div>
    );
  }
}

export default hot(module)(App);
