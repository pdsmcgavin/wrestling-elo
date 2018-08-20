const oddsCalculator = teamsElos => {
  const rlist = teamsElos.map(
    teamElos =>
      teamElos.reduce((acc, elo) => {
        return acc + Math.pow(10, elo / 400);
      }, 0) * teamElos.length
  );
  const rtotal = rlist.reduce((a, b) => {
    return a + b;
  });

  const elist = rlist.map(r => r / rtotal);

  return elist;
};

export default oddsCalculator;
