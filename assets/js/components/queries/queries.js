import gql from "graphql-tag";

export const GET_WRESTLERS_ELOS = gql`
  query getWrestlersElos($minMatches: Int!) {
    wrestlerStats(minMatches: $minMatches) {
      wrestlerStat {
        name
        aliases
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
  query getCurrentWrestlersElos(
    $minMatches: Int!
    $lastMatchWithinDays: Int!
    $date: String!
  ) {
    currentWrestlerStats(
      minMatches: $minMatches
      lastMatchWithinDays: $lastMatchWithinDays
      date: $date
    ) {
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

export const GET_WRESTLERS_ELOS_FOR_MATCH_UP = gql`
  query getCurrentWrestlersElos(
    $minMatches: Int!
    $lastMatchWithinDays: Int!
    $date: String!
  ) {
    currentWrestlerStats(
      minMatches: $minMatches
      lastMatchWithinDays: $lastMatchWithinDays
      date: $date
    ) {
      currentWrestlerStat {
        name
        currentElo {
          elo
        }
      }
    }
  }
`;

export const GET_WRESTLERS_ELOS_BY_HEIGHT = gql`
  query getWrestlersElosByHeight {
    wrestlerStats(minMatches: 50) {
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
    wrestlerStats(minMatches: 50) {
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

export const GET_WRESTLERS_ELOS_BY_YEAR = gql`
  query getWrestlersElosByYear {
    eloStatsByYear {
      eloStatsOfYear {
        year
        maxElo {
          elo
          name
        }
        minElo {
          elo
          name
        }
        maxEloDifference {
          eloDifference
          name
        }
        minEloDifference {
          eloDifference
          name
        }
      }
    }
  }
`;
