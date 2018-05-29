import React from "react";
import ReactTable from "react-table";
import "react-table/react-table.css";

export default class wrestlerEloTable extends React.Component {
  render() {
    const eloPrecision = 1;

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
            accessor: d => d.current_elo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
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
            accessor: d => d.max_elo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
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
            accessor: d => d.min_elo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
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

const floatStringSort = (a, b) => {
  return parseFloat(a) > parseFloat(b) ? 1 : -1;
};
