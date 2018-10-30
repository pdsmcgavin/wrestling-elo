import eloConsts from "../../../static/elo-consts.json";

const oddsCalculator = teamsElos => {
  const rlist = teamsElos.map(
    teamElos =>
      teamElos.reduce((acc, elo) => {
        return (
          acc +
          Math.pow(eloConsts.elo_base, elo / eloConsts.distribution_factor)
        );
      }, 0) * teamElos.length
  );
  const rtotal = rlist.reduce((a, b) => {
    return a + b;
  });

  const elist = rlist.map(r => r / rtotal);

  return elist;
};

export default oddsCalculator;
