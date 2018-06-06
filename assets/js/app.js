import React from "react";
import "phoenix_html";
import "react-phoenix";
import PropTypes from "prop-types";
import WrestlerEloTable from "./components/wrestler-elo-table";
import "../stylus/app.styl";
import { ApolloProvider } from "react-apollo";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";

const client = new ApolloClient({
  link: new HttpLink({ uri: "http://localhost:4000/api/graphql" }),
  cache: new InMemoryCache()
});

class App extends React.Component {
  render() {
    return (
      <div>
        <h2>WWElo</h2>
        <ApolloProvider client={client}>
          <WrestlerEloTable data={this.props.data} />
        </ApolloProvider>
      </div>
    );
  }
}

window.Components = {
  App
};

App.propTypes = {
  data: PropTypes.array // Define better in future
};
