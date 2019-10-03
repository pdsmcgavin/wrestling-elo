import React from "react";
import Loadable from "react-loadable";

const LoadingComponent = <div>Loading...</div>;

const LoadableCurrentWrestlersElos = Loadable({
  loader: () =>
    import(/* webpackChunkName: "currentWrestlersElos", prefetch: true */
    "./current-wrestlers-elos/current-wrestlers-elos"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableAllTimeWrestlersElos = Loadable({
  loader: () =>
    import(/* webpackChunkName: "allTimeWrestlersElos" */
    "./all-time-wrestlers-elos/all-time-wrestlers-elos"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableEloExtremeByYear = Loadable({
  loader: () =>
    import(/* webpackChunkName: "eloExtremeByYear" */
    "./elo-extremes-by-year/elo-extremes-by-year"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableMatchUpCalculator = Loadable({
  loader: () =>
    import(/* webpackChunkName: "matchUpCalculator" */
    "./match-up-calculator/match-up-calculator"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableWrestlerEloHistory = Loadable({
  loader: () =>
    import(/* webpackChunkName: "wrestlerEloHistory" */
    "./wrestler-elo-history/wrestler-elo-history"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableTitleContenders = Loadable({
  loader: () =>
    import(/* webpackChunkName: "titleContenders" */
    "./title-contenders/title-contenders"),
  loading() {
    return LoadingComponent;
  }
});

const LoadablePastEvents = Loadable({
  loader: () =>
    import(/* webpackChunkName: "pastEvents" */
    "./past-events/past-events"),
  loading() {
    return LoadingComponent;
  }
});

const LoadablePastEvent = Loadable({
  loader: () =>
    import(/* webpackChunkName: "pastEvent" */
    "./past-events/past-events-year/past-event/past-event"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableUpcomingEvents = Loadable({
  loader: () =>
    import(/* webpackChunkName: "upcomingEvents" */
    "./upcoming-events/upcoming-events"),
  loading() {
    return LoadingComponent;
  }
});

const LoadableFaq = Loadable({
  loader: () =>
    import(/* webpackChunkName: "faq" */
    "./faq/faq"),
  loading() {
    return LoadingComponent;
  }
});

export {
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
};
