require("@babel/register");
require.extensions[".css"] = function() {
  return null;
};
require.extensions[".styl"] = function() {
  return null;
};

const router = require("../router").default;
const Sitemap = require("react-router-sitemap").default;

const filterConfig = {
  isValid: false,
  rules: [/^\/$/]
};

new Sitemap(router())
  .filterPaths(filterConfig)
  .build("https://www.wwelo.com")
  .save("./static/sitemap.xml");
