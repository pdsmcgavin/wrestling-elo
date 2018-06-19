import gql from "graphql-tag";

export const GET_WRESTLERS_ELOS = gql`
  query getWrestlersElos {
    wrestlerStats(min_matches: 50) {
      wrestlerStat {
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

export const GET_CURRENT_WRESTLERS_ELOS = gql`
  query getCurrentWrestlersElos {
    currentWrestlerStats(min_matches: 10, last_match_within_days: 365) {
      currentWrestlerStat {
        name
        gender
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
        brand
      }
    }
  }
`;

export const GET_WRESTLERS_ELOS_BY_HEIGHT = gql`
  query getWrestlersElosByHeight {
    wrestlerStats(min_matches: 50) {
      wrestlerStat {
        height
        currentElo {
          elo
        }
        maxElo {
          elo
        }
        minElo {
          elo
        }
      }
    }
  }
`;

export const GET_WRESTLERS_ELOS_BY_WEIGHT = gql`
  query getWrestlersElosByWeight {
    wrestlerStats(min_matches: 1) {
      wrestlerStat {
        weight
        currentElo {
          elo
        }
        maxElo {
          elo
        }
        minElo {
          elo
        }
      }
    }
  }
`;
