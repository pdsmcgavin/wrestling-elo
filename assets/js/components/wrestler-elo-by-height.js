import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS_BY_HEIGHT } from "./queries/queries";
import PropTypes from "prop-types";
import "react-table/react-table.css";
import { ScatterplotChart } from "react-easy-chart";

class WrestlerEloByHeightChart extends React.Component {
  render() {
    const elosByHeight = (
      this.props.getWrestlersElosByHeight.wrestlerStats || []
    )
      .filter(wrestler => wrestler.height)
      .reduce(
        (acc, wrestler) =>
          acc.concat([
            {
              type: "Maximum Elo",
              x: wrestler.height,
              y: wrestler.maxElo.elo
            },
            {
              type: "Minimum Elo",
              x: wrestler.height,
              y: wrestler.minElo.elo
            },
            {
              type: "Current Elo",
              x: wrestler.height,
              y: wrestler.currentElo.elo
            }
          ]),
        []
      );

    return (
      <div>
        {this.props.getWrestlersElosByHeight.loading ? (
          <p>Loading...</p>
        ) : (
          <ScatterplotChart
            style={{ ".label": { fill: "black" } }}
            data={elosByHeight}
            axes
            axisLabels={{ x: "Height (cm)", y: "Elo" }}
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

WrestlerEloByHeightChart.propTypes = {
  getWrestlersElosByHeight: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_BY_HEIGHT, {
  name: "getWrestlersElosByHeight"
})(WrestlerEloByHeightChart);
