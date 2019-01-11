import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS_BY_WEIGHT } from "./queries/queries";
import PropTypes from "prop-types";
import "react-table/react-table.css";
import { ScatterplotChart } from "react-easy-chart";

class WrestlerEloByWeightChart extends React.Component {
  render() {
    const elosByWeight = (
      this.props.getWrestlersElosByWeight.wrestlerStats || []
    )
      .filter(wrestler => wrestler.weight)
      .reduce(
        (acc, wrestler) =>
          acc.concat([
            {
              type: "Maximum Elo",
              x: wrestler.weight,
              y: wrestler.maxElo.elo
            },
            {
              type: "Minimum Elo",
              x: wrestler.weight,
              y: wrestler.minElo.elo
            },
            {
              type: "Current Elo",
              x: wrestler.weight,
              y: wrestler.currentElo.elo
            }
          ]),
        []
      );

    return (
      <div>
        {this.props.getWrestlersElosByWeight.loading ? (
          <p>Loading...</p>
        ) : (
          <ScatterplotChart
            style={{ ".label": { fill: "black" } }}
            data={elosByWeight}
            axes
            axisLabels={{ x: "Weight (kg)", y: "Elo" }}
            width={900}
            height={600}
            margin={{ top: 20, right: 20, bottom: 20, left: 70 }}
            grid
            verticalGrid
          />
        )}
      </div>
    );
  }
}

WrestlerEloByWeightChart.propTypes = {
  getWrestlersElosByWeight: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_BY_WEIGHT, {
  name: "getWrestlersElosByWeight"
})(WrestlerEloByWeightChart);
