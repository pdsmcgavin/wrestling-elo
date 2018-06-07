import React from "react";
import { graphql } from "react-apollo";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import moment from "moment";
import { floatStringSort, dateStringSort } from "./utils/table-sort";

class WrestlerEloTable extends React.Component {
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
            accessor: d => d.currentElo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "current_elo_date",
            accessor: d => moment(d.currentElo.date).format("Do MMM YYYY"),
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
            accessor: d => d.maxElo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "max_elo_date",
            accessor: d => moment(d.maxElo.date).format("Do MMM YYYY"),
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
            accessor: d => d.minElo.elo.toFixed(eloPrecision),
            sortMethod: floatStringSort
          },
          {
            Header: "Date",
            id: "min_elo_date",
            accessor: d => moment(d.minElo.date).format("Do MMM YYYY"),
            sortMethod: dateStringSort
          }
        ]
      }
    ];

    const defaultSort = [{ id: "current_elo_value", desc: true }];

    return (
      <ReactTable
        data={
          this.props.getWrestlersElos.loading
            ? []
            : this.props.getWrestlersElos.wrestlerElos.wrestlerElo
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

const GET_WRESTLERS_ELOS = gql`
  query getWrestlersElos {
    wrestlerElos(min_matches: 50) {
      wrestlerElo {
        name
        currentElo {
          elo
          date
        }
        maxElo {
          elo
          date
        }
        minElo {
          elo
          date
        }
      }
    }
  }
`;

export default graphql(GET_WRESTLERS_ELOS, { name: "getWrestlersElos" })(
  WrestlerEloTable
);
