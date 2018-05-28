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
        columns: [
          {
            Header: "Value",
            id: "current_elo_value",
            accessor: d => d.current_elo.elo.toFixed(1)
          },
          {
            Header: "Date",
            accessor: "current_elo.date"
          }
        ]
      },
      {
        Header: "Maximum Elo",
        columns: [
          {
            Header: "Value",
            id: "max_elo_value",
            accessor: d => d.max_elo.elo.toFixed(1)
          },
          {
            Header: "Date",
            accessor: "max_elo.date"
          }
        ]
      },
      {
        Header: "Minimum Elo",
        columns: [
          {
            Header: "Value",
            id: "min_elo_value",
            accessor: d => d.min_elo.elo.toFixed(1)
          },
          {
            Header: "Date",
            accessor: "min_elo.date"
          }
        ]
      }
    ];

    return <ReactTable data={this.props.data} columns={columns} />;
  }
}
