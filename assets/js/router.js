import React from "react";
import { Route, Redirect, Switch } from "react-router-dom";
import root from "window-or-global";

import CurrentWrestlerEloTable from "./routes/current-wrestler-elos/current-wrestler-elo-table";
import WrestlerEloTable from "./routes/all-time-wrestler-elos/wrestler-elo-table";
import WrestlerEloByYearTable from "./routes/elo-extremes-by-year/wrestler-elo-by-year-table";
import MatchUpCalculator from "./routes/match-up-calculator/match-up-calculator";
import WrestlerEloHistory from "./routes/wrestler-elo-history/wrestler-elo-history";
import TitleContenders from "./routes/title-contenders/title-contenders";
import PastEvent from "./routes/past-events/past-event";

const Router = () => {
  root.dataLayer &&
    root.dataLayer.push({
      event: "pageView"
    });

  return (
    <Switch>
      <Route
        path={"/current-wrestlers-elos"}
        component={CurrentWrestlerEloTable}
      />
      <Route path={"/all-time-wrestlers-elos"} component={WrestlerEloTable} />
      <Route
        path={"/elo-extremes-by-year"}
        component={WrestlerEloByYearTable}
      />
      <Route path={"/wrestler-elo-history"} component={WrestlerEloHistory} />
      <Route path={"/match-up-calculator"} component={MatchUpCalculator} />
      <Route path={"/title-contenders"} component={TitleContenders} />
      <Route path={"/past-events/:year/:event"} component={PastEvent} />
      <Redirect from="/" to="/current-wrestlers-elos" />
    </Switch>
  );
};

export default Router;
