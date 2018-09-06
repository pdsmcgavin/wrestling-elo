import React from "react";
import PropTypes from "prop-types";
import {
  VictoryAxis,
  VictoryChart,
  VictoryGroup,
  VictoryLine,
  VictoryScatter,
  VictoryTheme,
  VictoryTooltip
} from "victory";

class WrestlerEloHistoryChart extends React.Component {
  constructor(props) {
    super(props);

    this.getDomainsFromHistory = wrestlerEloHistories => {
      const allData = wrestlerEloHistories.map(d => d.elos);

      const allDates = [].concat(...allData).map(d => d.x);
      const allElos = [].concat(...allData).map(d => d.y);

      return {
        minDate: new Date(Math.min(...allDates)),
        maxDate: new Date(Math.max(...allDates)),
        minElo: Math.min(...allElos),
        maxElo: Math.max(...allElos)
      };
    };
  }

  render() {
    const { wrestlerEloHistories, colours } = this.props;

    const dataExtrema = this.getDomainsFromHistory(wrestlerEloHistories);

    return (
      <VictoryChart
        scale={{ x: "time" }}
        height={450}
        width={1500}
        theme={VictoryTheme.material}
      >
        <VictoryAxis label={"Date"} />
        <VictoryAxis dependentAxis label={"Elo"} />
        <VictoryLine
          data={[
            { x: dataExtrema.minDate, y: 1200 },
            { x: dataExtrema.maxDate, y: 1200 }
          ]}
          style={{ data: { stroke: "grey", strokeWidth: 1 } }}
        />
        {wrestlerEloHistories.map((wrestlerEloHistory, index) => (
          <VictoryGroup
            color={colours[index]}
            key={index}
            labels={d => `Elo: ${d.y}`}
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
