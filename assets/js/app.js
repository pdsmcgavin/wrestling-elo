import React from "react";
import { InMemoryCache } from "apollo-cache-inmemory";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { ApolloProvider } from "react-apollo";
import { Helmet } from "react-helmet";
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
        <Helmet>
          <title>WWElo - Elo Rankings For Wrestlers</title>
          <meta
            name="description"
            content="Elo rankings for Wrestlers all across WWE from the current 
    superstars of RAW, SmackDown, NXT and 205 Live to all the legends 
    of the past 50+ years of sports entertainment."
          />
        </Helmet>
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
