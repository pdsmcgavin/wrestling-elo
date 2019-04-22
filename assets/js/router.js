import React from "react";
import { Route, Redirect, Switch } from "react-router-dom";
import Loadable from "react-loadable";
import root from "window-or-global";

const LoadableCurrentWrestlerEloTable = Loadable({
  loader: () =>
    import(/* webpackChunkName: "currentWrestlerEloTable", prefetch: true */
    "./routes/current-wrestler-elos/current-wrestler-elo-table"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableWrestlerEloTable = Loadable({
  loader: () =>
    import(/* webpackChunkName: "wrestlerEloTable" */
    "./routes/all-time-wrestler-elos/wrestler-elo-table"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableWrestlerEloByYearTable = Loadable({
  loader: () =>
    import(/* webpackChunkName: "wrestlerEloByYearTable" */
    "./routes/elo-extremes-by-year/wrestler-elo-by-year-table"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableMatchUpCalculator = Loadable({
  loader: () =>
    import(/* webpackChunkName: "matchUpCalculator" */
    "./routes/match-up-calculator/match-up-calculator"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableWrestlerEloHistory = Loadable({
  loader: () =>
    import(/* webpackChunkName: "wrestlerEloHistory" */
    "./routes/wrestler-elo-history/wrestler-elo-history"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableTitleContenders = Loadable({
  loader: () =>
    import(/* webpackChunkName: "titleContenders" */
    "./routes/title-contenders/title-contenders"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadablePastEvents = Loadable({
  loader: () =>
    import(/* webpackChunkName: "pastEvents" */
    "./routes/past-events/past-events"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadablePastEvent = Loadable({
  loader: () =>
    import(/* webpackChunkName: "pastEvent" */
    "./routes/past-events/past-events-year/past-event/past-event"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableUpcomingEvents = Loadable({
  loader: () =>
    import(/* webpackChunkName: "upcomingEvents" */
    "./routes/upcoming-events/upcoming-events"),
  loading() {
    return <div>Loading...</div>;
  }
});

const LoadableFaq = Loadable({
  loader: () =>
    import(/* webpackChunkName: "faq" */
    "./routes/faq/faq"),
  loading() {
    return <div>Loading...</div>;
  }
});

const Router = () => {
  root.dataLayer &&
    root.dataLayer.push({
      event: "pageView"
    });

  return (
    <Switch>
      <Route
        path={"/current-wrestlers-elos"}
        component={LoadableCurrentWrestlerEloTable}
      />
      <Route
        path={"/all-time-wrestlers-elos"}
        component={LoadableWrestlerEloTable}
      />
      <Route
        path={"/elo-extremes-by-year"}
        component={LoadableWrestlerEloByYearTable}
      />
      <Route
        path={"/wrestler-elo-history"}
        component={LoadableWrestlerEloHistory}
      />
      <Route
        path={"/match-up-calculator"}
        component={LoadableMatchUpCalculator}
      />
      <Route path={"/title-contenders"} component={LoadableTitleContenders} />
      <Route exact path={"/past-events"} component={LoadablePastEvents} />
      <Route path={"/past-events/:year/:event"} component={LoadablePastEvent} />
      <Route
        exact
        path={"/upcoming-events"}
        component={LoadableUpcomingEvents}
      />
      <Route exact path={"/faq"} component={LoadableFaq} />
      <Redirect from="/" to="/current-wrestlers-elos" />
    </Switch>
  );
};

export default Router;
