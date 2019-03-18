import React from "react";
import moment from "moment";
import PropTypes from "prop-types";
import { graphql, compose } from "react-apollo";
import { Helmet } from "react-helmet";
import ReactTable from "react-table";
import Select from "react-virtualized-select";

import "react-table/react-table.css";

import { EloPrecision, DateFormat } from "../../common/consts/elo-table";
import { GET_BRANDS, GET_CURRENT_WRESTLERS_ELOS } from "../../queries/queries";
import { todaysDateISO, previousDateISO } from "../../common/utils/iso-dates";
import rankChanges from "../../common/utils/rank-changes";
import { floatStringSort, dateStringSort } from "../../common/utils/table-sort";

import "./current-wrestler-elo-table.styl";

class CurrentWrestlerEloTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
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

  componentDidUpdate(props, prevState) {
    if (!prevState.selectedBrand) {
      this.setState({ selectedBrand: getBrands(props.getBrands) });
    }
  }

  render() {
    const { selectedBrand, selectedGender, nameToMatch } = this.state;

    const brandOptions = getBrands(this.props.getBrands);

    let data = this.props.getCurrentWrestlersElos.loading
      ? []
      : this.props.getCurrentWrestlersElos.currentWrestlerStats;

    const previousData = this.props.getPreviousCurrentWrestlersElos.loading
      ? []
      : this.props.getPreviousCurrentWrestlersElos.currentWrestlerStats;

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

    const defaultSort = [{ id: "currentEloValue", desc: true }];

    return (
      <React.Fragment>
        <Helmet>
          <title>
            WWElo - Current Wrestlers Elos - The Greatest Wrestlers Of The WWE
            Ranked
          </title>
          <meta
            name="description"
            content="Elo Rankings for Wrestlers of the WWE for all the 
    superstars of RAW, SmackDown, NXT and 205 Live."
          />
          <link
            rel="canonical"
            href="https://www.wwelo.com/current-wrestlers-elos"
          />
        </Helmet>
        <div className="table-filters">
          <div className="filter-container">
            <label className="filter-labels" htmlFor="name-filter">
              Name:{" "}
            </label>
            <input
              className="name-filter"
              id="name-filter"
              name="name-filter"
              type="text"
              value={this.state.value}
              onChange={this.handleNameChange}
            />
          </div>
          <div className="filter-container">
            <label className="filter-labels" htmlFor="gender-filter">
              Gender:{" "}
            </label>
            <Select
              className="gender-filter"
              id="gender-filter"
              name="gender-filter"
              value={selectedGender}
              onChange={this.handleGenderChange}
              options={[
                { value: "male", label: "Male" },
                { value: "female", label: "Female" }
              ]}
            />
          </div>
          <div className="filter-container">
            <label className="filter-labels" htmlFor="brand-filter">
              Brand:{" "}
            </label>
            <Select
              className="brand-filter"
              id="brand-filter"
              name="brand-filter"
              value={selectedBrand}
              onChange={this.handleBrandChange}
              options={brandOptions}
              multi
              removeSelected={true}
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
      </React.Fragment>
    );
  }
}

CurrentWrestlerEloTable.propTypes = {
  getBrands: PropTypes.object,
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
    selectedBrand &&
    selectedBrand.length > 0 &&
    selectedBrand.some(o => o.value == wrestler.brand) &&
    wrestler.name &&
    wrestler.name.toLowerCase().includes(nameToMatch.toLowerCase()) &&
    (!selectedGender || wrestler.gender === selectedGender.value)
  );
};

const getBrands = brandsQuery => {
  if (brandsQuery.loading) {
    return [];
  }

  return brandsQuery.brands.map(brand => {
    return { label: brand.name, value: brand.name };
  });
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
  }),
  graphql(GET_BRANDS, {
    name: "getBrands"
  })
)(CurrentWrestlerEloTable);
