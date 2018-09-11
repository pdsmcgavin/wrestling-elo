import React from "react";
import CurrentWrestlerEloTable from "./components/current-wrestler-elo-table";
import WrestlerEloTable from "./components/wrestler-elo-table";
import WrestlerEloByYearTable from "./components/wrestler-elo-by-year-table";
import WrestlerEloByHeight from "./components/wrestler-elo-by-height";
import WrestlerEloByWeight from "./components/wrestler-elo-by-weight";
import MatchUpCalculator from "./components/match-up-calculator";
import WrestlerEloHistory from "./components/wrestler-elo-history";

import { hot } from "react-hot-loader";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { Tab, Tabs, TabList, TabPanel } from "react-tabs";
import "react-tabs/style/react-tabs.css";
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
        <h2>WWElo</h2>
        <ApolloProvider client={client}>
          <Tabs>
            <TabList>
              <Tab>Active Wrestlers Elos</Tab>
              <Tab>All Wrestlers Elos</Tab>
              <Tab>Best/Worst of the Year</Tab>
              <Tab>Elos by Height</Tab>
              <Tab>Elos by Weight</Tab>
              <Tab>Match Up Calculator</Tab>
              <Tab>Wrestler Elo History</Tab>
            </TabList>

            <TabPanel>
              <CurrentWrestlerEloTable />
            </TabPanel>
            <TabPanel>
              <WrestlerEloTable />
            </TabPanel>
            <TabPanel>
              <WrestlerEloByYearTable />
            </TabPanel>
            <TabPanel>
              <WrestlerEloByHeight />
            </TabPanel>
            <TabPanel>
              <WrestlerEloByWeight />
            </TabPanel>
            <TabPanel>
              <MatchUpCalculator />
            </TabPanel>
            <TabPanel>
              <WrestlerEloHistory />
            </TabPanel>
          </Tabs>
        </ApolloProvider>
      </div>
    );
  }
}

export default hot(module)(App);
