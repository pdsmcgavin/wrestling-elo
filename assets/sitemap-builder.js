require("@babel/register");
require.extensions[".css"] = function() {
  return null;
};
require.extensions[".styl"] = function() {
  return null;
};
require.extensions[".png"] = function() {
  return null;
};

const axios = require("axios");
const reactRouterSitemap = require("react-router-sitemap");
const Sitemap = reactRouterSitemap.default;

const addEventUrls = require("./js/common/utils/add-event-urls").default;
const router = require("./js/router").default;

const filterConfig = {
  isValid: false,
  rules: [/^\/$/, /:/]
};

const postBody = {
  operationName: "getEvents",
  variables: { eventType: "ppv" },
  query:
    "query getEvents($eventType: String!) {\n  events(event_type: $eventType) {\n    name\n    date\n    id\n    __typename\n  }\n}\n"
};

axios
  .post("http://localhost:4000/api/graphql", postBody)
  .then(function(response) {
    const events = response.data.data.events;

    const eventsWithUrls = addEventUrls(events);

    const routes = new Sitemap(router());

    const pastEventsRoutes = eventsWithUrls.map(event => {
      return event.url;
    });

    routes.paths = [...routes.paths, ...pastEventsRoutes];

    routes
      .filterPaths(filterConfig)
      .build("https://www.wwelo.com")
      .save("./static/sitemap.xml");
  });
