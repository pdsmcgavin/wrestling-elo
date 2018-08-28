import React from "react";
import "react-select/dist/react-select.css";
import PropTypes from "prop-types";
import {
  VictoryChart,
  VictoryGroup,
  VictoryLegend,
  VictoryLine,
  VictoryScatter,
  VictoryTooltip
} from "victory";

class WrestlerEloHistoryChart extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { wrestlerEloHistories } = this.props;

    const colours = ["#C70039", "#2ECC71", "#7FB3D5", "#F5B041", "#8E44AD"];

    return (
      <div>
        <VictoryLegend
          height={25}
          width={1500}
          gutter={20}
          orientation="horizontal"
          data={wrestlerEloHistories.map((wrestlerEloHistory, index) => {
            return {
              name: wrestlerEloHistory.name,
              symbol: { fill: colours[index] }
            };
          })}
        />

        <VictoryChart scale={{ x: "time" }} height={450} width={1500}>
          {wrestlerEloHistories.map((wrestlerEloHistory, index) => (
            <VictoryGroup
              color={colours[index]}
              key={index}
              labels={d => `elo: ${d.y}`}
              labelComponent={<VictoryTooltip style={{ fontSize: 10 }} />}
              data={wrestlerEloHistory.elos}
            >
              <VictoryLine />
              <VictoryScatter />
            </VictoryGroup>
          ))}
        </VictoryChart>
      </div>
    );
  }
}

WrestlerEloHistoryChart.propTypes = {
  wrestlerEloHistories: PropTypes.array // Define better in future
};

export default WrestlerEloHistoryChart;
