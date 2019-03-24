import React from "react";
import {
  ExpansionPanel,
  ExpansionPanelDetails,
  ExpansionPanelSummary,
  List,
  Switch
} from "@material-ui/core";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import PropTypes from "prop-types";
import { graphql } from "react-apollo";

import addEventUrls from "../../common/utils/add-event-urls";
import LinkListItem from "../../navbar/components/link-list-item";
import { GET_EVENTS } from "../../queries/queries";
import groupBy from "../../common/utils/group-by";

class PastEventsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      sortDateDescending: false
    };

    this.eventsByYear = () => {
      const { getEvents } = this.props;
      const events = getEvents.events || [];

      const eventsWithUrls = addEventUrls(events);
      const eventsByYear = groupBy(eventsWithUrls, "year");

      return eventsByYear;
    };

    this.onSwitchSelect = () => {
      this.setState({ sortDateDescending: !this.state.sortDateDescending });
    };

    this.sortByState = (a, b) => {
      if (this.state.sortDateDescending) {
        return a < b ? 1 : -1;
      } else {
        return a > b ? 1 : -1;
      }
    };

    this.cleanEventName = name => {
      return name.replace(/^WWE\s/, "");
    };
  }

  render() {
    const eventsByYear = this.eventsByYear();

    return (
      <React.Fragment>
        <h1>Past Events</h1>
        <div>Sort by date descending: </div>
        <Switch onChange={this.onSwitchSelect} />
        <List>
          {Object.keys(eventsByYear)
            .sort(this.sortByState)
            .map(year => {
              const events = eventsByYear[year].sort((a, b) => {
                return this.sortByState(a.date, b.date);
              });

              return (
                <ExpansionPanel key={year}>
                  <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />}>
                    {year}
                  </ExpansionPanelSummary>
                  <ExpansionPanelDetails>
                    <List>
                      {events.map((event, index) => {
                        return (
                          <LinkListItem
                            text={this.cleanEventName(event.name)}
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
      </React.Fragment>
    );
  }
}

PastEventsList.propTypes = {
  getEvents: PropTypes.object,
  onClickHandler: PropTypes.func
};

export default graphql(GET_EVENTS, {
  name: "getEvents",
  options: {
    variables: {
      eventType: "ppv"
    }
  }
})(PastEventsList);
