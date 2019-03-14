import { floatStringSort, dateStringSort } from "./table-sort";

describe("floatStringSort", () => {
  test("returns an array sorted in ascending order", () => {
    const unSortedArray = [10, 0.1, 3.1, 3.0, "-10.2"];

    const expectedArray = ["-10.2", 0.1, 3.0, 3.1, 10];

    const sortedArray = unSortedArray.sort(floatStringSort);

    expect(sortedArray).toMatchObject(expectedArray);
  });
});

describe("dateStringSort", () => {
  test("returns an array sorted in ascending order", () => {
    const unSortedArray = [
      "31st Oct 2000",
      "1st Apr 2001",
      "1st Oct 2000",
      "1st Nov 2000",
      "31st Oct 1900"
    ];

    const expectedArray = [
      "31st Oct 1900",
      "1st Oct 2000",
      "31st Oct 2000",
      "1st Nov 2000",
      "1st Apr 2001"
    ];

    const sortedArray = unSortedArray.sort(dateStringSort);

    expect(sortedArray).toMatchObject(expectedArray);
  });
});
