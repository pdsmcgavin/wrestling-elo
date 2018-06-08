import React from "react";
import ReactDOM from "react-dom";
import WrestlerEloTable from "./components/wrestler-elo-table";
import "../stylus/app.styl";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { Tab, Tabs, TabList, TabPanel } from "react-tabs";
import "react-tabs/style/react-tabs.css";

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
              <Tab>Elos by Wrestler</Tab>
            </TabList>

            <TabPanel>
              <WrestlerEloTable />
            </TabPanel>
          </Tabs>
        </ApolloProvider>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("app"));
