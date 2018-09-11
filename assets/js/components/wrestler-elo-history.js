import React from "react";
import Select from "react-virtualized-select";
import {
  GET_WRESTLER_LIST,
  GET_WRESTLERS_ELO_HISTORIES
} from "./queries/queries";
import { graphql, Query } from "react-apollo";
import PropTypes from "prop-types";
import WrestlerEloHistoryChart from "./wrestler-elo-history-chart";
import { LineChartColours } from "./consts/colours";

class WrestlerEloHistory extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      wrestlers: []
    };

    this.handleWrestlerChange = selectedWrestler => {
      if (selectedWrestler.length <= 5) {
        this.setState({
          wrestlers: selectedWrestler
        });
      }
    };

    this.colours = LineChartColours;

    this.wrestlerLegend = (selectedWrestler, index) => {
      return (
        <div style={{ color: this.colours[index] }}>
          {selectedWrestler.label}
        </div>
      );
    };
  }

  render() {
    const { wrestlers } = this.state;

    const wrestlerList = this.props.getWrestlerList.loading
      ? []
      : this.props.getWrestlerList.wrestlerStats.wrestlerStat;

    const wrestlerDisplayList = wrestlerList
      .map(wrestler => {
        return {
          value: wrestler.id,
          label: wrestler.name
        };
      })
      .sort((a, b) => a.label.localeCompare(b.label));

    return (
      <div>
        <Select
          name="wrestlerDisplayList"
          value={wrestlers}
          valueRenderer={this.wrestlerLegend}
          onChange={this.handleWrestlerChange}
          options={wrestlerDisplayList}
          multi
          removeSelected={true}
        />
        <Query
          query={GET_WRESTLERS_ELO_HISTORIES}
          variables={{
            ids: this.state.wrestlers.map(wrestler => wrestler.value)
          }}
        >
          {({ loading, error, data }) => {
            if (loading) return null;
            if (error) return `Error!: ${error}`;

            const wrestlerEloHistories = data.wrestlerEloHistories.wrestlerEloHistory.map(
              (wrestler, index) => {
                return {
                  name: this.state.wrestlers[index].label,
                  elos: wrestler.elos.map(elo => {
                    return {
                      x: new Date(elo.date),
                      y: Math.round(elo.elo)
                    };
                  })
                };
              }
            );

            if (wrestlerEloHistories.length === 0) {
              return <div>Please select a wrestler</div>;
            }

            return (
              <WrestlerEloHistoryChart
                wrestlerEloHistories={wrestlerEloHistories}
                colours={this.colours}
              />
            );
          }}
        </Query>
      </div>
    );
  }
}

WrestlerEloHistory.propTypes = {
  getWrestlerList: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLER_LIST, {
  name: "getWrestlerList",
  options: {
    variables: {
      minMatches: 10
    }
  }
})(WrestlerEloHistory);
