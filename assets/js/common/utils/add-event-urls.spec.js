import { urlFromName } from "./add-event-urls";

describe("urlFromName", () => {
  test("replaces blocks of whitespace with a single hyphen", () => {
    const eventName = "the         spaces";

    const expectedUrl = "the-spaces";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("removes WWE from the beginning of a name", () => {
    const eventName = "wwe event";

    const expectedUrl = "event";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("removes WWF from the beginning of a name", () => {
    const eventName = "wwf event";

    const expectedUrl = "event";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("removes only the year from of a name", () => {
    const eventName = "event 2000 2";
    const eventYear = 2000;

    const expectedUrl = "event-2";

    const outputUrl = urlFromName(eventName, eventYear);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("returns a lowercase url when given an uppercase event", () => {
    const eventName = "UPPERCASE EVENT";

    const expectedUrl = "uppercase-event";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("replaces apostrophes with no hypen", () => {
    const eventName = "it's an event";

    const expectedUrl = "its-an-event";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("replaces other punctuation with a hypen", () => {
    const eventName = "Punc/tua/tion:the,replacement";

    const expectedUrl = "punc-tua-tion-the-replacement";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("removes trailing hypens", () => {
    const eventName = "event with a space after ";

    const expectedUrl = "event-with-a-space-after";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });
});
