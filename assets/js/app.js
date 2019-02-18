import React from "react";
import { InMemoryCache } from "apollo-cache-inmemory";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { ApolloProvider } from "react-apollo";
import { hot } from "react-hot-loader";

import "react-select/dist/react-select.css";
import "react-virtualized-select/styles.css";

import Router from "./components/router";
import SideDrawer from "./components/side-drawer";

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
          <SideDrawer />
          <div className="tab-content">
            <Router />
          </div>
        </ApolloProvider>
      </React.Fragment>
    );
  }
}

export default hot(module)(App);
