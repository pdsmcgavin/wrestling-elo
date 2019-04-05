import React from "react";
import PropTypes from "prop-types";
import { graphql, Query } from "react-apollo";
import { Helmet } from "react-helmet";
import { Redirect } from "react-router-dom";

import addEventUrls from "../../../../common/utils/add-event-urls";
import { GET_EVENT, GET_EVENTS } from "../../../../queries/queries";
import groupBy from "../../../../common/utils/group-by";

import "./past-event.styl";

class PastEvent extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { getEvents } = this.props;
    const { pathname } = this.props.location;

    const events = getEvents.events || [];

    const eventsWithUrls = addEventUrls(events);

    const event = eventsWithUrls.find(event => {
      return event.url === pathname;
    });

    const eventId = event && event.id;

    if (!eventId) {
      const bestEventMatch = eventsWithUrls.find(event => {
        return event.url.includes(pathname);
      });

      return bestEventMatch ? <Redirect to={bestEventMatch.url} /> : null;
    }

    return (
      <Query
        query={GET_EVENT}
        variables={{
          eventId
        }}
      >
        {({ loading, error, data }) => {
          if (loading) return null;
          if (error) return `Error!: ${error}`;

          const matches = data.event.matches;

          return (
            <div>
              <Helmet>
                <title>{`WWElo - ${event.name}`}</title>
                <link
                  rel="canonical"
                  href={`https://www.wwelo.com${pathname}`}
                />
              </Helmet>
              <h1 className="past-event-name">{event.name}</h1>
              <h2 className="past-event-date">{event.date}</h2>
              <div className="past-event-matches">
                {matches.map((match, index) => {
                  return <PastEventMatch match={match} key={index} />;
                })}
              </div>
            </div>
          );
        }}
      </Query>
    );
  }
}

const PastEventMatch = ({ match }) => {
  const teams = groupBy(match.participants, "matchTeam");

  return (
    <div className="past-event-match">
      <h3 className="past-event-stipulation">{match.stipulation}</h3>
      <div className="past-event-teams">
        {Object.keys(teams).map(index => {
          return <PastEventTeam team={teams[index]} key={index} />;
        })}
      </div>
    </div>
  );
};

const PastEventTeam = ({ team }) => {
  return (
    <div className="past-event-team">
      <div>{team[0].outcome}</div>
      {team.map((participant, index) => {
        return <PastEventParticipant participant={participant} key={index} />;
      })}
    </div>
  );
};

const PastEventParticipant = ({ participant }) => {
  return (
    <div className="past-event-participant">
      <h3>{participant.name}</h3>
      <PastEventEloChange participant={participant} />
    </div>
  );
};

const PastEventEloChange = ({ participant }) => {
  const eloChange = (participant.eloAfter - participant.eloBefore).toFixed(1);

  return (
    <div>
      {`${participant.eloBefore.toFixed(1)} -> ${participant.eloAfter.toFixed(
        1
      )} `}
      <div
        className={
          eloChange > 0
            ? "past-event-elo-change-win"
            : "past-event-elo-change-loss"
        }
      >
        {`${eloChange > 0 ? "+" : ""}${eloChange}`}
      </div>
    </div>
  );
};

PastEvent.propTypes = {
  getEvents: PropTypes.object,
  location: PropTypes.object
};

PastEventMatch.propTypes = {
  match: PropTypes.object
};

PastEventTeam.propTypes = {
  team: PropTypes.arrayOf(PropTypes.object)
};

PastEventParticipant.propTypes = {
  participant: PropTypes.object
};

PastEventEloChange.propTypes = {
  participant: PropTypes.object
};

export default graphql(GET_EVENTS, {
  name: "getEvents",
  options: {
    variables: {
      eventType: "ppv"
    }
  }
})(PastEvent);
