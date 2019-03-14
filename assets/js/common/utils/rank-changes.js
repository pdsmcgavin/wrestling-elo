const rankChanges = (elos, previousElos) => {
  let sortedElos = elos.slice().sort(compareElos);
  let sortedPreviousElos = previousElos.slice().sort(compareElos);

  return sortedElos.map((wrestler, index) => {
    const previousRank = sortedPreviousElos.findIndex(
      w => w.name === wrestler.name
    );

    return {
      ...wrestler,
      rankChange: previousRank >= 0 ? previousRank - index : "New Entry"
    };
  });
};

export default rankChanges;

const compareElos = (eloA, eloB) => {
  if (eloA.currentElo.elo < eloB.currentElo.elo) return 1;
  if (eloA.currentElo.elo > eloB.currentElo.elo) return -1;
  return 0;
};
