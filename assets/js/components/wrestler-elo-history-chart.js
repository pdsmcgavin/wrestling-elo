import React from "react";
import PropTypes from "prop-types";
import {
  VictoryChart,
  VictoryGroup,
  VictoryLine,
  VictoryScatter,
  VictoryTooltip
} from "victory";

class WrestlerEloHistoryChart extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { wrestlerEloHistories, colours } = this.props;

    return (
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
    );
  }
}

WrestlerEloHistoryChart.propTypes = {
  wrestlerEloHistories: PropTypes.array, // Define better in future
  colours: PropTypes.arrayOf(PropTypes.string)
};

export default WrestlerEloHistoryChart;
