import React from "react";
import Select from "react-select";
import "react-select/dist/react-select.css";
import {
  GET_WRESTLER_LIST,
  GET_WRESTLERS_ELO_HISTORIES
} from "./queries/queries";
import { graphql, Query } from "react-apollo";
import PropTypes from "prop-types";
import WrestlerEloHistoryChart from "./wrestler-elo-history-chart";

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
          onChange={this.handleWrestlerChange}
          options={wrestlerDisplayList}
          style={{ width: "250px" }}
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
