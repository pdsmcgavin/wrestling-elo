const addEventUrls = events => {
  const eventsWithUrls = events.map(event => {
    const event_url = urlFromName(event.name);

    const year = event.date.replace(/-.*$/, "");

    const url = "/past-events/" + year + "/" + event_url;

    return { ...event, url, year };
  });

  return eventsWithUrls;
};

export default addEventUrls;

export const urlFromName = name => {
  return name
    .replace(/[^\w\s]/g, " ")
    .replace(/\s+/g, "-")
    .toLowerCase()
    .replace(/^ww[ef]-?/, "")
    .replace(/-\d*$/, "");
};
