import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS_BY_WEIGHT } from "./queries/queries";
import PropTypes from "prop-types";
import {
  VictoryAxis,
  VictoryChart,
  VictoryScatter,
  VictoryTheme
} from "victory";
import { ScatterChartColours } from "./consts/colours";
import { ChartLabels } from "./consts/labels";

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
              type: ChartLabels.max,
              x: wrestler.weight,
              y: wrestler.maxElo.elo,
              symbol: "triangleUp"
            },
            {
              type: ChartLabels.current,
              x: wrestler.weight,
              y: wrestler.currentElo.elo
            },
            {
              type: ChartLabels.min,
              x: wrestler.weight,
              y: wrestler.minElo.elo,
              symbol: "triangleDown"
            }
          ]),
        []
      );

    return (
      <div>
        {this.props.getWrestlersElosByWeight.loading ? (
          <p>Loading...</p>
        ) : (
          <VictoryChart width={900} height={400} theme={VictoryTheme.material}>
            <VictoryAxis label="Weight (kg)" />
            <VictoryAxis dependentAxis label="Elo" />
            <VictoryScatter
              data={elosByWeight}
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

WrestlerEloByWeightChart.propTypes = {
  getWrestlersElosByWeight: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_BY_WEIGHT, {
  name: "getWrestlersElosByWeight"
})(WrestlerEloByWeightChart);
