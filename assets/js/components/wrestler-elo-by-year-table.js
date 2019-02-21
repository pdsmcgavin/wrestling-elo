import React from "react";
import PropTypes from "prop-types";
import { graphql } from "react-apollo";
import { Helmet } from "react-helmet";
import ReactTable from "react-table";

import "react-table/react-table.css";

import { EloPrecision } from "./consts/elo-table";
import { GET_WRESTLERS_ELOS_BY_YEAR } from "./queries/queries";
import { floatStringSort } from "./utils/table-sort";

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
            accessor: d => d.maxElo.elo.toFixed(EloPrecision),
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
            accessor: d => d.minElo.elo.toFixed(EloPrecision),
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
              d.maxEloDifference.eloDifference.toFixed(EloPrecision),
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
              d.minEloDifference.eloDifference.toFixed(EloPrecision),
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
      <React.Fragment>
        <Helmet>
          <title>
            WWElo - Elo Extremes By Year - The Best And Worst Wrestlers By Year
          </title>
          <meta
            name="description"
            content="The greatest, most improved, worst and least improved wrestlers from each and every year of the WWE according to their Elo."
          />
        </Helmet>
        <ReactTable
          data={
            this.props.getWrestlersElosByYear.loading
              ? []
              : this.props.getWrestlersElosByYear.eloStatsByYear
          }
          noDataText={
            this.props.getWrestlersElosByYear.loading
              ? "Loading..."
              : "No data found"
          }
          columns={columns}
          defaultSorted={defaultSort}
        />
      </React.Fragment>
    );
  }
}

WrestlerEloByYearTable.propTypes = {
  getWrestlersElosByYear: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS_BY_YEAR, {
  name: "getWrestlersElosByYear"
})(WrestlerEloByYearTable);
