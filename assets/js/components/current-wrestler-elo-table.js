import React from "react";
import { graphql, compose } from "react-apollo";
import { GET_CURRENT_WRESTLERS_ELOS } from "./queries/queries";
import PropTypes from "prop-types";
import ReactTable from "react-table";
import "react-table/react-table.css";
import Select from "react-select";
import "react-select/dist/react-select.css";
import moment from "moment";
import { floatStringSort, dateStringSort } from "./utils/table-sort";
import { todaysDateISO, previousDateISO } from "./utils/iso-dates";
import rankChanges from "./utils/rank-changes";
import { brands } from "./consts/brands";
import { eloPrecision, dateFormat } from "./consts/elo-table";

class CurrentWrestlerEloTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedBrand: brands,
      selectedGender: null,
      nameToMatch: ""
    };

    this.handleBrandChange = selectedBrand => {
      this.setState({
        selectedBrand
      });
    };

    this.handleGenderChange = selectedGender => {
      this.setState({
        selectedGender
      });
    };

    this.handleNameChange = event => {
      this.setState({
        nameToMatch: event.target.value
      });
    };
  }

  render() {
    const { selectedBrand, selectedGender, nameToMatch } = this.state;

    let data = this.props.getCurrentWrestlersElos.loading
      ? []
      : this.props.getCurrentWrestlersElos.currentWrestlerStats
          .currentWrestlerStat;

    const previousData = this.props.getPreviousCurrentWrestlersElos.loading
      ? []
      : this.props.getPreviousCurrentWrestlersElos.currentWrestlerStats
          .currentWrestlerStat;

    data = rankChanges(data, previousData);

    const filteredData = data.filter(wrestler =>
      displayWrestler(wrestler, selectedBrand, selectedGender, nameToMatch)
    );

    const columns = [
      {
        Header: "Rank Change",
        accessor: "rankChange"
      },
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
      <div>
        <div
          style={{
            display: "flex",
            alignItems: "center",
            flexWrap: "wrap",
            justifyContent: "space-around"
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <span style={{ marginRight: "10px" }}>Name: </span>
            <input
              type="text"
              value={this.state.value}
              onChange={this.handleNameChange}
            />
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <span style={{ marginRight: "10px" }}>Gender: </span>
            <Select
              name="genderFilter"
              value={selectedGender}
              onChange={this.handleGenderChange}
              options={[
                { value: "male", label: "Male" },
                { value: "female", label: "Female" }
              ]}
              style={{ minWidth: "150px" }}
            />
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <span style={{ marginRight: "10px" }}>Brand: </span>
            <Select
              name="brand-filter"
              value={selectedBrand}
              onChange={this.handleBrandChange}
              options={brands}
              multi
              removeSelected={true}
              style={{ minWidth: "400px" }}
            />
          </div>
        </div>

        <ReactTable
          data={filteredData}
          noDataText={
            this.props.getCurrentWrestlersElos.loading
              ? "Loading..."
              : "No data found"
          }
          columns={columns}
          defaultSorted={defaultSort}
        />
      </div>
    );
  }
}

CurrentWrestlerEloTable.propTypes = {
  getCurrentWrestlersElos: PropTypes.object, // Define better in future
  getPreviousCurrentWrestlersElos: PropTypes.object // Define better in future
};

const displayWrestler = (
  wrestler,
  selectedBrand,
  selectedGender,
  nameToMatch
) => {
  return (
    selectedBrand.length > 0 &&
    selectedBrand.some(o => o.value == wrestler.brand) &&
    wrestler.name &&
    wrestler.name.toLowerCase().includes(nameToMatch.toLowerCase()) &&
    (!selectedGender || wrestler.gender === selectedGender.value)
  );
};

export default compose(
  graphql(GET_CURRENT_WRESTLERS_ELOS, {
    name: "getCurrentWrestlersElos",
    options: {
      variables: {
        minMatches: 10,
        lastMatchWithinDays: 365,
        date: todaysDateISO()
      }
    }
  }),
  graphql(GET_CURRENT_WRESTLERS_ELOS, {
    name: "getPreviousCurrentWrestlersElos",
    options: {
      variables: {
        minMatches: 10,
        lastMatchWithinDays: 365,
        date: previousDateISO(7)
      }
    }
  })
)(CurrentWrestlerEloTable);
