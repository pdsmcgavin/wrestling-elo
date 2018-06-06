import React from "react";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import moment from "moment";
import { floatStringSort, dateStringSort } from "./utils/table-sort";

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
            id: "current_elo_date",
            accessor: d => moment(d.current_elo.date).format("Do MMM YYYY"),
            sortMethod: dateStringSort
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
            id: "max_elo_date",
            accessor: d => moment(d.max_elo.date).format("Do MMM YYYY"),
            sortMethod: dateStringSort
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
            id: "min_elo_date",
            accessor: d => moment(d.min_elo.date).format("Do MMM YYYY"),
            sortMethod: dateStringSort
          }
        ]
      }
    ];

    const defaultSort = [{ id: "current_elo_value", desc: true }];

    return (
      <ReactTable
        data={this.props.data}
        columns={columns}
        defaultSorted={defaultSort}
      />
    );
  }
}

wrestlerEloTable.propTypes = {
  data: PropTypes.array // Define better in future
};
