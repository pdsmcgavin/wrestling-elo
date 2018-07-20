import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS } from "./queries/queries";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import moment from "moment";
import { floatStringSort, dateStringSort } from "./utils/table-sort";
import { eloPrecision, dateFormat } from "./consts/elo-table";

class WrestlerEloTable extends React.Component {
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
            id: "currentEloValue",
            accessor: d => d.currentElo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "currentEloDate",
            accessor: d => moment(d.currentElo.date).format(dateFormat),
            sortMethod: dateStringSort
          }
        ]
      },
      {
        Header: "Maximum Elo",
        columns: [
          {
            Header: "Value",
            id: "maxEloValue",
            accessor: d => d.maxElo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "maxEloDate",
            accessor: d => moment(d.maxElo.date).format(dateFormat),
            sortMethod: dateStringSort
          }
        ]
      },
      {
        Header: "Minimum Elo",
        columns: [
          {
            Header: "Value",
            id: "minEloValue",
            accessor: d => d.minElo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "minEloDate",
            accessor: d => moment(d.minElo.date).format(dateFormat),
            sortMethod: dateStringSort
          }
        ]
      }
    ];

    const defaultSort = [{ id: "maxEloValue", desc: true }];

    return (
      <ReactTable
        data={
          this.props.getWrestlersElos.loading
            ? []
            : this.props.getWrestlersElos.wrestlerStats.wrestlerStat
        }
        noDataText={
          this.props.getWrestlersElos.loading ? "Loading..." : "No data found"
        }
        columns={columns}
        defaultSorted={defaultSort}
      />
    );
  }
}

WrestlerEloTable.propTypes = {
  getWrestlersElos: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS, { name: "getWrestlersElos" })(
  WrestlerEloTable
);
