import React from "react";
import ReactTable from "react-table";
import "css-loader!react-table/react-table.css";
import _ from "lodash";

export default class wrestlerEloTable extends React.Component {
  render() {
    const columns = [
      {
        Header: "Name",
        accessor: "name"
      },
      {
        Header: "Current Elo",
        accessor: "current_elo"
      },
      {
        Header: "Max Elo",
        accessor: "max_elo"
      },
      {
        Header: "Min Elo",
        accessor: "min_elo"
      }
    ];

    var eloTableData = [];

    for (var i = 0; i < this.props.data.length; i++) {
      if (this.props.data[i].elos.length >= 50) {
        eloTableData.push({
          name: this.props.data[i].name,
          current_elo: Math.round(_.last(this.props.data[i].elos).elo),
          max_elo: Math.round(_.maxBy(this.props.data[i].elos, "elo").elo),
          min_elo: Math.round(_.minBy(this.props.data[i].elos, "elo").elo)
        });
      }
    }

    return <ReactTable data={eloTableData} columns={columns} />;
  }
}
