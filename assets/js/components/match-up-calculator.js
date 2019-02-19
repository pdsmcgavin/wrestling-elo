import React from "react";
import PropTypes from "prop-types";
import { graphql } from "react-apollo";
import Select from "react-virtualized-select";
import root from "window-or-global";

import { GET_WRESTLERS_ELOS_FOR_MATCH_UP } from "./queries/queries";
import { todaysDateISO } from "./utils/iso-dates";
import oddsCalculator from "./utils/odds-calculator";

import "./match-up-calculator.styl";

class MatchUpCalculator extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      wrestlers: [[]],
      expectedOdds: []
    };

    this.handleWrestlerChange = (selectedWrestlers, team) => {
      const newlySelectedWrestler = selectedWrestlers.find(
        wrestler => !this.state.wrestlers.flat().includes(wrestler)
      );

      if (newlySelectedWrestler) {
        root.dataLayer &&
          root.dataLayer.push({
            event: "wrestlerSelect",
            wrestlerName: newlySelectedWrestler.label
          });
      }

      const updatedWrestlers = this.state.wrestlers;
      updatedWrestlers[team] = selectedWrestlers;

      const wrestlerElos = updatedWrestlers.map(team =>
        team.map(wrestler => wrestler.currentElo)
      );

      const expectedOdds = oddsCalculator(wrestlerElos).map(
        odd => `${(odd * 100).toFixed(1)}%`
      );

      this.setState({
        wrestlers: updatedWrestlers,
        expectedOdds: expectedOdds
      });
    };
  }

  render() {
    const { wrestlers, expectedOdds } = this.state;

    const wrestlerList = this.props.getCurrentWrestlersElos.loading
      ? []
      : this.props.getCurrentWrestlersElos.currentWrestlerStats;

    const wrestlerDisplayList = wrestlerList
      .map(wrestler => {
        return {
          value: wrestler.name,
          label: wrestler.name,
          currentElo: wrestler.currentElo.elo
        };
      })
      .sort((a, b) => a.value.localeCompare(b.value));

    return (
      <div className="match-up-calculator-container">
        <SelectionAndOdds
          wrestlerDisplayList={wrestlerDisplayList}
          wrestlers={wrestlers}
          team={0}
          expectedOdds={expectedOdds}
          handleWrestlerChange={this.handleWrestlerChange}
        />
        <span className="versus"> vs. </span>
        <SelectionAndOdds
          wrestlerDisplayList={wrestlerDisplayList}
          wrestlers={wrestlers}
          team={1}
          expectedOdds={expectedOdds}
          handleWrestlerChange={this.handleWrestlerChange}
        />
        <span className="versus"> vs. </span>
        <SelectionAndOdds
          wrestlerDisplayList={wrestlerDisplayList}
          wrestlers={wrestlers}
          team={2}
          expectedOdds={expectedOdds}
          handleWrestlerChange={this.handleWrestlerChange}
        />
        <span className="versus"> vs. </span>
        <SelectionAndOdds
          wrestlerDisplayList={wrestlerDisplayList}
          wrestlers={wrestlers}
          team={3}
          expectedOdds={expectedOdds}
          handleWrestlerChange={this.handleWrestlerChange}
        />
      </div>
    );
  }
}

const SelectionAndOdds = ({
  wrestlers,
  wrestlerDisplayList,
  team,
  expectedOdds,
  handleWrestlerChange
}) => {
  return (
    <div>
      <Select
        className="team-selection"
        name="wrestlerDisplayList"
        value={wrestlers[team]}
        onChange={wrestlers => handleWrestlerChange(wrestlers, team)}
        options={wrestlerDisplayList}
        multi
        removeSelected={true}
      />
      <div className="team-chances">
        {wrestlers[team] && wrestlers[team].length > 0 && expectedOdds[team]}
      </div>
    </div>
  );
};

MatchUpCalculator.propTypes = {
  getCurrentWrestlersElos: PropTypes.object // Define better in future
};

SelectionAndOdds.propTypes = {
  wrestlers: PropTypes.arrayOf(PropTypes.arrayOf(PropTypes.object)),
  wrestlerDisplayList: PropTypes.arrayOf(PropTypes.object),
  team: PropTypes.number.isRequired,
  expectedOdds: PropTypes.arrayOf(PropTypes.number),
  handleWrestlerChange: PropTypes.func
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
