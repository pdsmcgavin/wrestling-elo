import React from "react";
import ReactTable from "react-table";
import "react-table/react-table.css";
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

    return <ReactTable data={this.props.data} columns={columns} />;
  }
}
