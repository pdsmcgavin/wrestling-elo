import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS_BY_YEAR } from "./queries/queries";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import { floatStringSort } from "./utils/table-sort";
import { eloPrecision } from "./consts/elo-table";

class WrestlerEloByYearTable extends React.Component {
  render() {
    const columns = [
      {
        Header: "Year",
        accessor: "year"
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
            Header: "Name",
            accessor: "maxElo.name"
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
            Header: "Name",
            accessor: "minElo.name"
          }
        ]
      },
      {
        Header: "Maximum Elo Change",
        columns: [
          {
            Header: "Value",
            id: "maxEloDifferenceValue",
            accessor: d =>
              d.maxEloDifference.eloDifference.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Name",
            accessor: "maxEloDifference.name"
          }
        ]
      },
      {
        Header: "Minimum Elo Change",
        columns: [
          {
            Header: "Value",
            id: "minEloDifferenceValue",
            accessor: d =>
              d.minEloDifference.eloDifference.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Name",
            accessor: "minEloDifference.name"
          }
        ]
      }
    ];

    const defaultSort = [{ id: "year", desc: true }];

    return (
      <ReactTable
        data={
          this.props.getWrestlersElosByYear.loading
            ? []
            : this.props.getWrestlersElosByYear.eloStatsByYear.eloStatsOfYear
        }
        noDataText={
          this.props.getWrestlersElosByYear.loading
            ? "Loading..."
            : "No data found"
        }
        columns={columns}
        defaultSorted={defaultSort}
      />
    );
  }
}

WrestlerEloByYearTable.propTypes = {
  getWrestlersElosByYear: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_BY_YEAR, {
  name: "getWrestlersElosByYear"
})(WrestlerEloByYearTable);
