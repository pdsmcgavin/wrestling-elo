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

  test("removes years from the end of a name", () => {
    const eventName = "event 2000";

    const expectedUrl = "event";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("returns a lowercase url when given an uppercase event", () => {
    const eventName = "UPPERCASE EVENT";

    const expectedUrl = "uppercase-event";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });

  test("replaces punctuation with a hypen", () => {
    const eventName = "Punc/tua/tion:the,replacement";

    const expectedUrl = "punc-tua-tion-the-replacement";

    const outputUrl = urlFromName(eventName);

    expect(outputUrl).toEqual(expectedUrl);
  });
});
