const addEventUrls = events => {
  let eventsWithUrls = events.map(event => {
    const year = event.date.replace(/-.*$/, "");

    const event_url = urlFromName(event.name, year);

    const url = "/past-events/" + year + "/" + event_url;

    return { ...event, url, year };
  });

  return fixDuplicateUrls(eventsWithUrls);
};

export default addEventUrls;

export const urlFromName = (name, year) => {
  return name
    .replace(year, "")
    .replace("'", "")
    .replace(/[^\w\s]/g, " ")
    .replace(/\s+/g, "-")
    .replace(/-$/, "")
    .toLowerCase()
    .replace(/^ww[ef]-?/, "");
};

const fixDuplicateUrls = events => {
  const duplicates = events.reduce((acc, value, index, array) => {
    const urlIndex = array.findIndex(element => {
      return element.url == value.url;
    });

    if (urlIndex !== index && urlIndex > 0) {
      acc.push(value.url);
    }

    return acc;
  }, []);

  const fixedEvents = events.map(eventWithUrl => {
    if (duplicates.includes(eventWithUrl.url)) {
      const city = eventWithUrl.location.split(",")[0];

      const cityUrl = city.toLowerCase().replace(/\s+/g, "-");

      eventWithUrl.url = eventWithUrl.url + "-" + cityUrl;
      eventWithUrl.name = eventWithUrl.name + ` (${city})`;
    }

    return eventWithUrl;
  });

  return fixedEvents;
};
