import React from "react";
import {
  ExpansionPanel,
  ExpansionPanelDetails,
  ExpansionPanelSummary,
  List
} from "@material-ui/core";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import PropTypes from "prop-types";
import { graphql } from "react-apollo";

import addEventUrls from "./common/add-event-urls";
import LinkListItem from "./common/link-list-item";
import { GET_EVENTS } from "./queries/queries";
import groupBy from "./utils/group-by";

import "./past-events-list.styl";

class PastEventsList extends React.Component {
  constructor(props) {
    super(props);
  }

  eventsByYear() {
    const { getEvents } = this.props;
    const events = getEvents.events || [];

    const eventsWithUrls = addEventUrls(events);
    const eventsByYear = groupBy(eventsWithUrls, "year");

    return eventsByYear;
  }

  render() {
    const eventsByYear = this.eventsByYear();

    return (
      <ExpansionPanel className="past-events-list-panel">
        <ExpansionPanelSummary
          expandIcon={<ExpandMoreIcon />}
          className="past-events-list-summary"
        >
          Past Events
        </ExpansionPanelSummary>
        <ExpansionPanelDetails className="past-events-list-details">
          <List>
            {Object.keys(eventsByYear).map(year => {
              const events = eventsByYear[year].sort((a, b) => {
                return a.date > b.date ? 1 : -1;
              });

              return (
                <ExpansionPanel className="past-events-list-panel" key={year}>
                  <ExpansionPanelSummary
                    className="past-events-list-summary"
                    expandIcon={<ExpandMoreIcon />}
                  >
                    {year}
                  </ExpansionPanelSummary>
                  <ExpansionPanelDetails className="past-events-list-details">
                    <List>
                      {events.map((event, index) => {
                        return (
                          <LinkListItem
                            text={event.name}
                            route={event.url}
                            key={index}
                          />
                        );
                      })}
                    </List>
                  </ExpansionPanelDetails>
                </ExpansionPanel>
              );
            })}
          </List>
        </ExpansionPanelDetails>
      </ExpansionPanel>
    );
  }
}

PastEventsList.propTypes = {
  getEvents: PropTypes.object
};

export default graphql(GET_EVENTS, {
  name: "getEvents",
  options: {
    variables: {
      eventType: "ppv"
    }
  }
})(PastEventsList);
