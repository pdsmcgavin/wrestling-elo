import oddsCalculator from "./odds-calculator";

describe("equal elos", () => {
  describe("returns equal odds", () => {
    test("for a singles match", () => {
      const expectedOdds = [0.5, 0.5];
      const inputtedElos = [[1200], [1200]];

      const outputtedOdds = oddsCalculator(inputtedElos);

      expect(outputtedOdds).toEqual(expectedOdds);
    });

    test("for a fatal 4-way match", () => {
      const expectedOdds = [0.25, 0.25, 0.25, 0.25];
      const inputtedElos = [[1200], [1200], [1200], [1200]];

      const outputtedOdds = oddsCalculator(inputtedElos);

      expect(outputtedOdds).toEqual(expectedOdds);
    });

    test("for a tag team match", () => {
      const expectedOdds = [0.5, 0.5];
      const inputtedElos = [[1200, 1200], [1200, 1200]];

      const outputtedOdds = oddsCalculator(inputtedElos);

      expect(outputtedOdds).toEqual(expectedOdds);
    });
  });

  describe("returns different odds", () => {
    test("for a 2v1 handicap match", () => {
      const expectedOdds = [0.8, 0.2];
      const inputtedElos = [[1200, 1200], [1200]];

      const outputtedOdds = oddsCalculator(inputtedElos);

      expect(outputtedOdds).toEqual(expectedOdds);
    });
  });
});
