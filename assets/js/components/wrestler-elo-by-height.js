import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS_BY_HEIGHT } from "./queries/queries";
import PropTypes from "prop-types";
import {
  VictoryAxis,
  VictoryChart,
  VictoryScatter,
  VictoryTheme
} from "victory";
import { ScatterChartColours } from "./consts/colours";
import { ChartLabels } from "./consts/labels";

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
              type: ChartLabels.max,
              x: wrestler.height,
              y: wrestler.maxElo.elo,
              symbol: "triangleUp"
            },
            {
              type: ChartLabels.current,
              x: wrestler.height,
              y: wrestler.currentElo.elo
            },
            {
              type: ChartLabels.min,
              x: wrestler.height,
              y: wrestler.minElo.elo,
              symbol: "triangleDown"
            }
          ]),
        []
      );

    return (
      <div>
        {this.props.getWrestlersElosByHeight.loading ? (
          <p>Loading...</p>
        ) : (
          <VictoryChart width={900} height={400} theme={VictoryTheme.material}>
            <VictoryAxis label="Height (cm)" />
            <VictoryAxis dependentAxis label="Elo" />
            <VictoryScatter
              data={elosByHeight}
              style={{
                data: {
                  fill: d =>
                    d.type === ChartLabels.max
                      ? ScatterChartColours.red
                      : d.type === ChartLabels.min
                      ? ScatterChartColours.orange
                      : ScatterChartColours.blue
                }
              }}
            />
          </VictoryChart>
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
