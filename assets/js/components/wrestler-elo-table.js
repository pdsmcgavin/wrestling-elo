import React from "react";
import joinable from "joinable";
import moment from "moment";
import PropTypes from "prop-types";
import { graphql } from "react-apollo";
import { Helmet } from "react-helmet";
import ReactTable from "react-table";

import "react-table/react-table.css";

import { EloPrecision, DateFormat } from "./consts/elo-table";
import { GET_WRESTLERS_ELOS } from "./queries/queries";
import { floatStringSort, dateStringSort } from "./utils/table-sort";

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
      <React.Fragment>
        <Helmet>
          <title>
            WWElo - All Time Wrestlers Elos - The Greatest Wrestlers Of All Time
            Ranked
          </title>
          <meta
            name="description"
            content="Elo Rankings for Wrestlers of WWE across from the current 
    superstars of RAW, SmackDown, NXT and 205 Live to all the legends 
    of the past 50+ years of sports entertainment."
          />
          <link
            rel="canonical"
            href="https://www.wwelo.com/all-time-wrestlers-elos"
          />
        </Helmet>
        <ReactTable
          data={
            this.props.getWrestlersElos.loading
              ? []
              : this.props.getWrestlersElos.wrestlerStats
          }
          noDataText={
            this.props.getWrestlersElos.loading ? "Loading..." : "No data found"
          }
          columns={columns}
          defaultSorted={defaultSort}
        />
      </React.Fragment>
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
