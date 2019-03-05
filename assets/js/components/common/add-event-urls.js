const addEventUrls = events => {
  const eventsWithUrls = events.map(event => {
    const event_url = event.name
      .replace(/[^\w\s]/g, "")
      .replace(/\s/g, "-")
      .toLowerCase()
      .replace(/^wwe-?/, "")
      .replace(/-\d*$/, "");

    const year = event.date.replace(/-.*$/, "");

    const url = "/past-events/" + year + "/" + event_url;

    return { ...event, url, year };
  });

  return eventsWithUrls;
};

export default addEventUrls;
