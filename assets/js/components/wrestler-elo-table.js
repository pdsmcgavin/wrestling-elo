import React from "react";
import { graphql } from "react-apollo";
import { GET_WRESTLERS_ELOS } from "./queries/queries";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import moment from "moment";
import { floatStringSort, dateStringSort } from "./utils/table-sort";
import { EloPrecision, DateFormat } from "./consts/elo-table";
import joinable from "joinable";

class WrestlerEloTable extends React.Component {
  render() {
    const columns = [
      {
        Header: "Name",
        accessor: "name"
      },
      {
        Header: "Aliases",
        id: "aliases",
        accessor: d => joinable(...d.aliases, { separator: ", " })
      },
      {
        Header: "Current Elo",
        columns: [
          {
            Header: "Value",
            id: "currentEloValue",
            accessor: d => d.currentElo.elo.toFixed(EloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "currentEloDate",
            accessor: d => moment(d.currentElo.date).format(DateFormat),
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
            accessor: d => d.maxElo.elo.toFixed(EloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "maxEloDate",
            accessor: d => moment(d.maxElo.date).format(DateFormat),
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
            accessor: d => d.minElo.elo.toFixed(EloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "minEloDate",
            accessor: d => moment(d.minElo.date).format(DateFormat),
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
        style={{ height: "800px" }}
      />
    );
  }
}

WrestlerEloTable.propTypes = {
  getWrestlersElos: PropTypes.object // Define better in future
};

export default graphql(GET_WRESTLERS_ELOS, {
  name: "getWrestlersElos",
  options: {
    variables: {
      minMatches: 50
    }
  }
})(WrestlerEloTable);
