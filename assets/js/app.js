import React from "react";
import ReactDOM from "react-dom";
import CurrentWrestlerEloTable from "./components/current-wrestler-elo-table";
import WrestlerEloTable from "./components/wrestler-elo-table";
import WrestlerEloByHeight from "./components/wrestler-elo-by-height";

import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { Tab, Tabs, TabList, TabPanel } from "react-tabs";
import "react-tabs/style/react-tabs.css";
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
              <Tab>Elos by Height</Tab>
            </TabList>

            <TabPanel>
              <CurrentWrestlerEloTable />
            </TabPanel>
            <TabPanel>
              <WrestlerEloTable />
            </TabPanel>
            <TabPanel>
              <WrestlerEloByHeight />
            </TabPanel>
          </Tabs>
        </ApolloProvider>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("app"));
