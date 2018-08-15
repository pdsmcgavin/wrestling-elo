import React from "react";
import Select from "react-select";
import "react-select/dist/react-select.css";
import { GET_WRESTLERS_ELOS_FOR_MATCH_UP } from "./queries/queries";
import { graphql } from "react-apollo";
import PropTypes from "prop-types";

class MatchUpCalculator extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedWrestler: null
    };

    this.handleWrestlersChange = selectedWrestler => {
      this.setState({
        selectedWrestler
      });
    };
  }

  render() {
    const { selectedWrestler } = this.state;

    const wrestlers = this.props.getWrestlersElos.loading
      ? []
      : this.props.getWrestlersElos.wrestlerStats.wrestlerStat;
    const wrestlerDisplayList = wrestlers.map(wrestler => {
      return { value: wrestler.name, label: wrestler.name };
    });

    return (
      <div>
        <h3>Match Up</h3>
        <Select
          name="wrestlerDisplayList"
          value={selectedWrestler}
          onChange={this.handleWrestlersChange}
          options={wrestlerDisplayList}
          style={{ minWidth: "250px" }}
        />
      </div>
    );
  }
}

MatchUpCalculator.propTypes = {
  getWrestlersElos: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_FOR_MATCH_UP, {
  name: "getWrestlersElos",
  options: {
    variables: {
      minMatches: 10
    }
  }
})(MatchUpCalculator);
