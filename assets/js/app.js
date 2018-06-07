import React from "react";
import ReactDOM from "react-dom";
import WrestlerEloTable from "./components/wrestler-elo-table";
import "../stylus/app.styl";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";

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
          <WrestlerEloTable />
        </ApolloProvider>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("app"));
