import rankChanges from "./rank-changes";

describe("rankChanges", () => {
  test("returns an array of wrestlers now with their rank change appended on each", () => {
    const previousElo = [
      {
        name: "WRESTLER 1",
        currentElo: { elo: 1200 }
      },
      {
        name: "WRESTLER 2",
        currentElo: { elo: 1201 }
      },
      {
        name: "WRESTLER 3",
        currentElo: { elo: 1202 }
      },
      {
        name: "WRESTLER 4",
        currentElo: { elo: 1203 }
      },
      {
        name: "WRESTLER 5",
        currentElo: { elo: 1204 }
      }
    ];

    const nowElo = [
      {
        name: "WRESTLER 1",
        currentElo: { elo: 1305 }
      },
      {
        name: "WRESTLER 2",
        currentElo: { elo: 1301 }
      },
      {
        name: "WRESTLER 3",
        currentElo: { elo: 1302 }
      },
      {
        name: "WRESTLER 4",
        currentElo: { elo: 1303 }
      },
      {
        name: "WRESTLER 5",
        currentElo: { elo: 1304 }
      }
    ];

    const expectedRankChange = [
      {
        name: "WRESTLER 1",
        currentElo: { elo: 1305 },
        rankChange: 4
      },
      {
        name: "WRESTLER 2",
        currentElo: { elo: 1301 },
        rankChange: -1
      },
      {
        name: "WRESTLER 3",
        currentElo: { elo: 1302 },
        rankChange: -1
      },
      {
        name: "WRESTLER 4",
        currentElo: { elo: 1303 },
        rankChange: -1
      },
      {
        name: "WRESTLER 5",
        currentElo: { elo: 1304 },
        rankChange: -1
      }
    ];

    const returnedRankChange = rankChanges(nowElo, previousElo);

    expect(returnedRankChange).toEqual(
      expect.arrayContaining(expectedRankChange)
    );
  });
});
