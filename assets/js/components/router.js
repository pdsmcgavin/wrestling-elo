import React from "react";
import { Route, Redirect, Switch } from "react-router-dom";

import CurrentWrestlerEloTable from "./current-wrestler-elo-table";
import WrestlerEloTable from "./wrestler-elo-table";
import WrestlerEloByYearTable from "./wrestler-elo-by-year-table";
import MatchUpCalculator from "./match-up-calculator";
import WrestlerEloHistory from "./wrestler-elo-history";
import TitleContenders from "./title-contenders";

const Router = () => {
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
      <Redirect from="/" to="/current-wrestlers-elos" />
    </Switch>
  );
};

export default Router;
