import React from "react";
import { graphql } from "react-apollo";
import { GET_CURRENT_WRESTLERS_ELOS } from "./queries/queries";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import moment from "moment";
import { floatStringSort, dateStringSort } from "./utils/table-sort";

class CurrentWrestlerEloTable extends React.Component {
  render() {
    const eloPrecision = 1;
    const dateFormat = "Do MMM YYYY";

    const columns = [
      {
        Header: "Name",
        accessor: "name"
      },
      {
        Header: "Brand",
        accessor: "brand"
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

    const defaultSort = [{ id: "currentEloValue", desc: true }];

    return (
      <ReactTable
        data={
          this.props.getCurrentWrestlersElos.loading
            ? []
            : this.props.getCurrentWrestlersElos.currentWrestlerStats
                .currentWrestlerStat
        }
        noDataText={
          this.props.getCurrentWrestlersElos.loading
            ? "Loading..."
            : "No data found"
        }
        columns={columns}
        defaultSorted={defaultSort}
      />
    );
  }
}

CurrentWrestlerEloTable.propTypes = {
  getCurrentWrestlersElos: PropTypes.object // Define better in future
};

export default graphql(GET_CURRENT_WRESTLERS_ELOS, {
  name: "getCurrentWrestlersElos"
})(CurrentWrestlerEloTable);
