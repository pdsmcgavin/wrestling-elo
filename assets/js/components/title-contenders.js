import React from "react";
import { GET_ROSTER_CURRENT_ELOS, GET_TITLE_HOLDERS } from "./queries/queries";
import { todaysDateISO } from "./utils/iso-dates";
import { graphql, compose } from "react-apollo";
import PropTypes from "prop-types";
import { sortBy } from "lodash";
import { EloPrecision } from "./consts/elo-table";
import oddsCalculator from "./utils/odds-calculator";

import "./title-contenders.styl";

class TitleHolders extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { getCurrentWrestlersElos, getTitleHolders } = this.props;

    const titleHolders = getTitleHolders.titleHolders || [];

    const currentWrestlerStats =
      getCurrentWrestlersElos.currentWrestlerStats || [];

    const titleHolderAndContenders = titleHolders.map(titleHolder => {
      return holderAndContenders(titleHolder, currentWrestlerStats, 3);
    });

    return (
      <React.Fragment>
        <div className="title-holder-and-contenders content-title">
          <h2 className="title-holder">Belt and Current Champion</h2>
          <div className="contenders">
            <div className="wrestler">
              <div className="contender">
                <h2>Contender</h2>
                <h2>Elo</h2>
              </div>
              <h2>Odds</h2>
            </div>
          </div>
        </div>

        {titleHolderAndContenders.map((titleHolderAndContender, index) => {
          return topContendersDisplay(titleHolderAndContender, index);
        })}
      </React.Fragment>
    );
  }
}

const holderAndContenders = (titleHolder, wrestlerElos, numberOfContenders) => {
  const currentHolder =
    wrestlerElos.length > 0 &&
    wrestlerElos.find(wrestler => wrestler.name == titleHolder.name);

  const eligibleWrestlers = wrestlerElos.filter(wrestler => {
    return (
      wrestler.brand == titleHolder.brand &&
      wrestler.gender == titleHolder.gender &&
      wrestler.name != titleHolder.name
    );
  });

  const topContenders = sortBy(eligibleWrestlers, ["currentElo.elo"])
    .reverse()
    .slice(0, numberOfContenders);

  return { titleInfo: titleHolder, currentHolder, topContenders };
};

const topContendersDisplay = (
  { titleInfo, currentHolder, topContenders },
  index
) => {
  return (
    currentHolder && (
      <div key={index} className="title-holder-and-contenders">
        <div className="title-holder">
          <div>{titleInfo.beltName}</div>
          <div className="wrestler">
            <div>{currentHolder.name}</div>
            <div>{currentHolder.currentElo.elo.toFixed(EloPrecision)}</div>
          </div>
        </div>
        <div className="contenders">
          {topContenders.map((contender, contenderIndex) => {
            return (
              <div className="wrestler" key={contenderIndex}>
                <div className="contender">
                  <div>{contender.name}</div>
                  <div>{contender.currentElo.elo.toFixed(EloPrecision)}</div>
                </div>
                <div>
                  {(
                    oddsCalculator([
                      [contender.currentElo.elo],
                      [currentHolder.currentElo.elo]
                    ])[0] * 100
                  ).toFixed(1) + "%"}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    )
  );
};

TitleHolders.propTypes = {
  getCurrentWrestlersElos: PropTypes.object,
  getTitleHolders: PropTypes.object
};

topContendersDisplay.propTypes = {
  titleInfo: PropTypes.object,
  currentHolder: PropTypes.object,
  topContenders: PropTypes.object
};

export default compose(
  graphql(GET_TITLE_HOLDERS, {
    name: "getTitleHolders"
  }),
  graphql(GET_ROSTER_CURRENT_ELOS, {
    name: "getCurrentWrestlersElos",
    options: {
      variables: {
        minMatches: 1,
        lastMatchWithinDays: 365,
        date: todaysDateISO()
      }
    }
  })
)(TitleHolders);
