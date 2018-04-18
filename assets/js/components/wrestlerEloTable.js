import React from "react";
import ReactTable from "react-table";
import "css-loader!react-table/react-table.css";

export default class wrestlerEloTable extends React.Component {
  render() {
    const columns = [
      {
        Header: "Name",
        accessor: "name"
      },
      {
        Header: "Current Elo",
        accessor: "current_elo"
      },
      {
        Header: "Max Elo",
        accessor: "max_elo"
      },
      {
        Header: "Min Elo",
        accessor: "min_elo"
      }
    ];

    var eloTableData = [
      { name: "Braun Strowman", current_elo: 2000, min_elo: 20, max_elo: 2200 }
    ];

    return <ReactTable data={eloTableData} columns={columns} />;
  }
}
