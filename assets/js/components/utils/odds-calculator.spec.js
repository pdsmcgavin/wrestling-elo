import oddsCalculator from "./odds-calculator";

test("equal elos returns equal odds", () => {
  const expectedOdds = [0.5, 0.5];
  const inputtedElos = [1200, 1200];

  const outputtedOdds = oddsCalculator(inputtedElos);

  expect(outputtedOdds).toEqual(expectedOdds);
});
