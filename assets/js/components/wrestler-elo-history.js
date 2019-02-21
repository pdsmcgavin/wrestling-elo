import React from "react";
import PropTypes from "prop-types";
import { graphql, Query } from "react-apollo";
import { Helmet } from "react-helmet";
import Select from "react-virtualized-select";
import root from "window-or-global";

import { LineChartColours } from "./consts/colours";
import {
  GET_WRESTLER_LIST,
  GET_WRESTLERS_ELO_HISTORIES
} from "./queries/queries";
import WrestlerEloHistoryChart from "./wrestler-elo-history-chart";

class WrestlerEloHistory extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      wrestlers: []
    };

    this.handleWrestlerChange = selectedWrestlers => {
      const newlySelectedWrestler = selectedWrestlers.find(
        wrestler => !this.state.wrestlers.includes(wrestler)
      );

      if (newlySelectedWrestler) {
        root.dataLayer &&
          root.dataLayer.push({
            event: "wrestlerSelect",
            wrestlerName: newlySelectedWrestler.label
          });
      }

      if (selectedWrestlers.length <= 5) {
        this.setState({
          wrestlers: selectedWrestlers
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
      : this.props.getWrestlerList.wrestlerStats;

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
        <Helmet>
          <title>
            WWElo - Wrestler Elo History - Compare And Contrast The Careers Of
            WWE Wrestlers
          </title>
          <meta
            name="description"
            content="Compare the highs and lows of multiple wrestlers' careers from the entire history of the WWE."
          />
        </Helmet>
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

            const wrestlerEloHistories = data.wrestlerEloHistories.map(
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
      minMatches: 50
    }
  }
})(WrestlerEloHistory);
