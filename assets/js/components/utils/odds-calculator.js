const oddsCalculator = elos => {
  const expectedScore1 = 1 / (1 + Math.pow(10, (elos[1] - elos[0]) / 400));
  const expectedScore2 = 1 / (1 + Math.pow(10, (elos[0] - elos[1]) / 400));

  return [expectedScore1, expectedScore2];
};

export default oddsCalculator;
