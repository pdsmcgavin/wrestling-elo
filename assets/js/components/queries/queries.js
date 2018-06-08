import gql from "graphql-tag";

export const GET_WRESTLERS_ELOS = gql`
  query getWrestlersElos {
    wrestlerElos(min_matches: 1) {
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
