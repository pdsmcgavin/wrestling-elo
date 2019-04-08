import React from "react";
import PropTypes from "prop-types";
import { graphql, Query } from "react-apollo";
import { Helmet } from "react-helmet";

import { GET_EVENT, GET_UPCOMING_EVENTS } from "../../queries/queries";
import groupBy from "../../common/utils/group-by";
import oddsCalculator from "../../common/utils/odds-calculator";

class UpcomingEventsList extends React.Component {
  render() {
    const upcomingEvents = this.props.getUpcomingEvents.events || [];
    return (
      <React.Fragment>
        <h1>Upcoming Events</h1>
        {upcomingEvents.map((upcomingEvent, index) => {
          return (
            <Query
              query={GET_EVENT}
              variables={{ eventId: upcomingEvent.id }}
              key={index}
            >
              {({ loading, error, data }) => {
                if (loading) return null;
                if (error) return `Error!: ${error}`;

                const matches = data.event.matches;

                if (!matches || matches.length === 0) {
                  return <div />;
                }

                return (
                  <React.Fragment>
                    <Helmet>
                      <title>{"WWElo - Upcoming Events"}</title>
                      <link
                        rel="canonical"
                        href={"https://www.wwelo.com/upcoming-events"}
                      />
                    </Helmet>
                    <h1 className="past-event-name">{data.event.name}</h1>
                    <h2 className="past-event-date">{data.event.date}</h2>
                    <div className="past-event-matches">
                      {matches.map((match, index) => {
                        return <UpcomingEventMatch match={match} key={index} />;
                      })}
                    </div>
                  </React.Fragment>
                );
              }}
            </Query>
          );
        })}
      </React.Fragment>
    );
  }
}

UpcomingEventsList.propTypes = {
  getUpcomingEvents: PropTypes.object
};

export default graphql(GET_UPCOMING_EVENTS, {
  name: "getUpcomingEvents",
  options: {
    variables: {
      eventType: "ppv"
    }
  }
})(UpcomingEventsList);

const UpcomingEventMatch = ({ match }) => {
  const teams = groupBy(match.participants, "matchTeam");
  const teamElos = Object.values(teams).map(team => {
    return team.map(participant => {
      return participant.eloBefore;
    });
  });
  const teamOdds = oddsCalculator(teamElos);

  return (
    <div className="past-event-match">
      <h3 className="past-event-stipulation">{match.stipulation}</h3>
      <div className="past-event-teams">
        {Object.keys(teams).map(index => {
          return (
            <UpcomingEventTeam
              team={teams[index]}
              odds={teamOdds[index]}
              key={index}
            />
          );
        })}
      </div>
    </div>
  );
};

const UpcomingEventTeam = ({ team, odds }) => {
  return (
    <div className="past-event-team">
      <div>{(odds * 100).toFixed(1)}%</div>
      {team.map((participant, index) => {
        return (
          <UpcomingEventParticipant participant={participant} key={index} />
        );
      })}
    </div>
  );
};

const UpcomingEventParticipant = ({ participant }) => {
  return (
    <div className="past-event-participant">
      <h3>{participant.name}</h3>
      <UpcomingEventEloAndOdds participant={participant} />
    </div>
  );
};

const UpcomingEventEloAndOdds = ({ participant }) => {
  return <div>{`${participant.eloBefore.toFixed(1)}`}</div>;
};

UpcomingEventMatch.propTypes = {
  match: PropTypes.object
};

UpcomingEventTeam.propTypes = {
  team: PropTypes.arrayOf(PropTypes.object),
  odds: PropTypes.number
};

UpcomingEventParticipant.propTypes = {
  participant: PropTypes.object
};

UpcomingEventEloAndOdds.propTypes = {
  participant: PropTypes.object
};
