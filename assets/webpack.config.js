const path = require("path");
const CompressionPlugin = require("compression-webpack-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const LodashModuleReplacementPlugin = require("lodash-webpack-plugin");

module.exports = {
  entry: "./js/app.js",
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/app.js",
    publicPath: "http://localhost:8080/",
    globalObject: "window"
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },

      {
        test: /\.(css|styl)$/,
        exclude: /node_modules/,
        use: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"]
      },

      {
        test: /react-table.css$/,
        use: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"]
      }
    ]
  },
  plugins: [
    new CompressionPlugin(), //compresses react
    new UglifyJsPlugin(), //minify everything
    new LodashModuleReplacementPlugin()
  ],
  mode: "production"
};
