import gql from "graphql-tag";

export const GET_WRESTLER_LIST = gql`
  query getWrestlersElos($minMatches: Int!) {
    wrestlerStats(minMatches: $minMatches) {
      id
      name
    }
  }
`;

export const GET_WRESTLERS_ELOS = gql`
  query getWrestlersElos($minMatches: Int!) {
    wrestlerStats(minMatches: $minMatches) {
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
      name
      currentElo {
        elo
      }
    }
  }
`;

export const GET_WRESTLERS_ELO_HISTORIES = gql`
  query getWrestlersEloHistories($ids: [Int]!) {
    wrestlerEloHistories(ids: $ids) {
      id
      elos {
        elo
        date
      }
    }
  }
`;

export const GET_WRESTLERS_ELOS_BY_HEIGHT = gql`
  query getWrestlersElosByHeight {
    wrestlerStats(minMatches: 50) {
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
`;

export const GET_WRESTLERS_ELOS_BY_WEIGHT = gql`
  query getWrestlersElosByWeight {
    wrestlerStats(minMatches: 50) {
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
`;

export const GET_WRESTLERS_ELOS_BY_YEAR = gql`
  query getWrestlersElosByYear {
    eloStatsByYear {
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
`;

export const GET_TITLE_HOLDERS = gql`
  query getTitleHolders {
    titleHolders {
      name
      beltName
      gender
      brand
    }
  }
`;

export const GET_EVENTS = gql`
  query getEvents($eventType: String!) {
    events(event_type: $eventType) {
      name
      date
      event_type
    }
  }
`;

export const GET_ROSTER_CURRENT_ELOS = gql`
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
      name
      gender
      currentElo {
        elo
      }
      brand
    }
  }
`;
