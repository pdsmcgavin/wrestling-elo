const path = require("path");
const webpack = require("webpack");
const CompressionPlugin = require("compression-webpack-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const WriteFilePlugin = require("write-file-webpack-plugin");

const environment = process.env.NODE_ENV || "development";
const isProduction = environment == "production";

const plugins = [
  new CopyWebpackPlugin([
    {
      from: path.resolve(__dirname, "./static"),
      to: path.resolve(__dirname, "../priv/static")
    }
  ])
];

if (isProduction) {
  plugins.concat([
    new CompressionPlugin(), //compresses react
    new UglifyJsPlugin(), //minify everything
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
  ]);
} else {
  plugins.push(new WriteFilePlugin()); // Otherwise webpack-dev-server doesn't use copy-webpack-plugin
}

module.exports = {
  entry: ["@babel/polyfill", "./js/main.js"],
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/main.js",
    publicPath: "http://0.0.0.0:8080/"
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
        use: ["style-loader", "css-loader", "stylus-loader"]
      },

      {
        test: /(react-router-tabs|react-table|react-select|react-virtualized-select\/styles).css$/,
        use: ["style-loader", "css-loader"]
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        loader: "url-loader?limit=100000"
      }
    ]
  },
  plugins,
  mode: isProduction ? "production" : "development"
};
