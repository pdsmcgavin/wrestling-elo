import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS_BY_YEAR } from "./queries/queries";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import { floatStringSort } from "./utils/table-sort";

class WrestlerEloByYearTable extends React.Component {
  render() {
    const eloPrecision = 1;

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
      }
    ];

    const defaultSort = [{ id: "year", asc: true }];

    return (
      <ReactTable
        data={
          this.props.getWrestlersElosByYear.loading
            ? []
            : this.props.getWrestlersElosByYear.maxMinElosByYear
                .maxMinElosOfYear
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
