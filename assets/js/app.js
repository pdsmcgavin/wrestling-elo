import React from "react";
import "phoenix_html";
import "react-phoenix";
import WrestlerEloTable from "./components/wrestlerEloTable";
import "../stylus/app.styl";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";

const client = new ApolloClient({
  link: new HttpLink(),
  cache: new InMemoryCache()
});

class App extends React.Component {
  render() {
    return (
      <ApolloProvider client={client}>
        <WrestlerEloTable data={this.props.data} />
      </ApolloProvider>
    );
  }
}

window.Components = {
  App
};
