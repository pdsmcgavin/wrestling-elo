import React from "react";
import Select from "react-select";
import "react-select/dist/react-select.css";
import { GET_WRESTLERS_ELOS_FOR_MATCH_UP } from "./queries/queries";
import { graphql } from "react-apollo";
import PropTypes from "prop-types";
import oddsCalculator from "./utils/odds-calculator";
import { todaysDateISO } from "./utils/iso-dates";

class MatchUpCalculator extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedWrestler1: null,
      selectedWrestler2: null
    };

    this.handleWrestler1Change = selectedWrestler => {
      this.setState({
        selectedWrestler1: selectedWrestler
      });
    };

    this.handleWrestler2Change = selectedWrestler => {
      this.setState({
        selectedWrestler2: selectedWrestler
      });
    };
  }

  render() {
    const { selectedWrestler1, selectedWrestler2 } = this.state;

    const wrestlers = this.props.getCurrentWrestlersElos.loading
      ? []
      : this.props.getCurrentWrestlersElos.currentWrestlerStats
          .currentWrestlerStat;

    const wrestlerDisplayList = wrestlers
      .map(wrestler => {
        return {
          value: wrestler.name,
          label: wrestler.name,
          currentElo: wrestler.currentElo.elo
        };
      })
      .sort((a, b) => a.value.localeCompare(b.value));

    return (
      <div>
        <div
          style={{
            display: "flex",
            alignItems: "center",
            flexWrap: "wrap",
            justifyContent: "center",
            padding: "25px"
          }}
        >
          <Select
            name="wrestlerDisplayList"
            value={selectedWrestler1}
            onChange={this.handleWrestler1Change}
            options={wrestlerDisplayList}
            style={{ minWidth: "250px" }}
          />
          <div style={{ paddingLeft: "10px", paddingRight: "10px" }}> vs. </div>
          <Select
            name="wrestlerDisplayList"
            value={selectedWrestler2}
            onChange={this.handleWrestler2Change}
            options={wrestlerDisplayList}
            style={{ minWidth: "250px" }}
          />
        </div>
        <div>{matchUpDisplay(selectedWrestler1, selectedWrestler2)}</div>
      </div>
    );
  }
}

const matchUpDisplay = (wrestler1, wrestler2) => {
  if (!wrestler1 || !wrestler2) return null;

  const expectedOdds = oddsCalculator([
    [wrestler1.currentElo],
    [wrestler2.currentElo]
  ]);

  return (
    <div style={{ textAlign: "center" }}>
      {wrestler1.label} has a {(expectedOdds[0] * 100).toFixed(1)}% chance of
      beating {wrestler2.label}
    </div>
  );
};

MatchUpCalculator.propTypes = {
  getCurrentWrestlersElos: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_FOR_MATCH_UP, {
  name: "getCurrentWrestlersElos",
  options: {
    variables: {
      minMatches: 1,
      lastMatchWithinDays: 365,
      date: todaysDateISO()
    }
  }
})(MatchUpCalculator);
