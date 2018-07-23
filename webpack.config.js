// webpack.config.js, pdso/
const path = require('path');

const webpack = require('webpack');


module.exports = {
  module: {
    rules: [
      {  // coffeescript with React JSX
        test: /\.coffee$/,
        use: [
          {
            loader: 'babel-loader',
            options: {
              presets: [ "@babel/preset-react", ],
            },
          },
          // compile coffee first
          { loader: 'coffee-loader', },
        ],
      },
    ],
  },
  plugins: [
    new webpack.DllReferencePlugin({
      context: __dirname,
      manifest: require('./build/manifest-ui_lib.json'),
    }),
    new webpack.DllReferencePlugin({
      context: __dirname,
      manifest: require('./build/manifest-main_lib.json'),
    }),
  ],
  resolve: {
    extensions: [
      '.js',
      '.coffee',
    ],
  },

  entry: {
    // use ui_lib
    options: './src/options.coffee',
    popup: './src/popup.coffee',
    // use main_lib
    main: './src/main.coffee',
    // no lib
    contents: './src/contents.coffee',
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'xpi/js'),
  },

  // add this to avoid `eval()`
  devtool: 'source_map',
  mode: 'development',
};
