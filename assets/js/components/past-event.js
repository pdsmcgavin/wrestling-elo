import React from "react";
import { graphql } from "react-apollo";
import PropTypes from "prop-types";

import addEventUrls from "./common/add-event-urls";
import { GET_EVENTS } from "./queries/queries";

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

    return (
      <React.Fragment>
        <h1>{eventId}</h1>
      </React.Fragment>
    );
  }
}

PastEvent.propTypes = {
  getEvents: PropTypes.object,
  location: PropTypes.object
};

export default graphql(GET_EVENTS, {
  name: "getEvents",
  options: {
    variables: {
      eventType: "ppv"
    }
  }
})(PastEvent);
