const path = require("path");
const webpack = require("webpack");
const CompressionPlugin = require("compression-webpack-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");

const environment = process.env.NODE_ENV || "development";
const isProduction = environment == "production";

module.exports = {
  entry: "./js/app.js",
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/app.js",
    publicPath: "http://localhost:8080/"
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: isProduction
              ? [
                  ["@babel/preset-env", { modules: false }],
                  "@babel/react",
                  "minify"
                ]
              : [["@babel/preset-env", { modules: false }], "@babel/react"]
          }
        }
      },

      {
        test: /\.(css|styl)$/,
        exclude: /node_modules/,
        use: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"]
      },

      {
        test: /(react-tabs|react-table).css$/,
        use: ["style-loader", "css-loader", "postcss-loader", "stylus-loader"]
      }
    ]
  },
  plugins: isProduction
    ? [
        new CompressionPlugin(), //compresses react
        new UglifyJsPlugin(), //minify everything
        new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
      ]
    : [],
  mode: isProduction ? "production" : "development"
};
