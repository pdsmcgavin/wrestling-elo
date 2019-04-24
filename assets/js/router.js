import React from "react";
import { Route, Redirect, Switch } from "react-router-dom";
import root from "window-or-global";

import {
  LoadableCurrentWrestlersElos,
  LoadableAllTimeWrestlersElos,
  LoadableEloExtremeByYear,
  LoadableWrestlerEloHistory,
  LoadableMatchUpCalculator,
  LoadableTitleContenders,
  LoadablePastEvents,
  LoadablePastEvent,
  LoadableUpcomingEvents,
  LoadableFaq
} from "./routes/loadable-routes";

const Router = () => {
  root.dataLayer &&
    root.dataLayer.push({
      event: "pageView"
    });

  return (
    <Switch>
      <Route
        path={"/current-wrestlers-elos"}
        component={LoadableCurrentWrestlersElos}
      />
      <Route
        path={"/all-time-wrestlers-elos"}
        component={LoadableAllTimeWrestlersElos}
      />
      <Route
        path={"/elo-extremes-by-year"}
        component={LoadableEloExtremeByYear}
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
