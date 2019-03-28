const addEventUrls = events => {
  const eventsWithUrls = events.map(event => {
    const year = event.date.replace(/-.*$/, "");

    const event_url = urlFromName(event.name, year);

    const url = "/past-events/" + year + "/" + event_url;

    return { ...event, url, year };
  });

  return eventsWithUrls;
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
