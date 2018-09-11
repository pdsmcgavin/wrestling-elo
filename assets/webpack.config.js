const path = require("path");
const webpack = require("webpack");
const CompressionPlugin = require("compression-webpack-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

const environment = process.env.NODE_ENV || "development";
const isProduction = environment == "production";

module.exports = {
  entry: "./js/main.js",
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/main.js",
    publicPath: "http://localhost:8080/"
  },
  devServer: {
    headers: {
      "Access-Control-Allow-Origin": "*"
    }
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
        test: /(react-tabs|react-table|react-select|react-virtualized-select\/styles).css$/,
        use: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"]
      }
    ]
  },
  plugins: isProduction
    ? [
        new CompressionPlugin(), //compresses react
        new UglifyJsPlugin(), //minify everything
        new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
        new CopyWebpackPlugin([
          {
            from: "./static",
            to: path.resolve(__dirname, "../priv/static")
          }
        ])
      ]
    : [],
  mode: isProduction ? "production" : "development"
};
