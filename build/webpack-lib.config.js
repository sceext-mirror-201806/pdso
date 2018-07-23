// webpack-lib.config.js, pdso/build/
const path = require('path');

const webpack = require('webpack');


module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/,
        loader: 'style-loader!css-loader',
      }
    ],
  },

  plugins: [
    new webpack.DllPlugin({
      name: '[name]_[hash]',
      path: path.resolve(__dirname, 'manifest-[name].json'),
    }),
  ],

  entry: {
    ui_lib: [
      'react',
      'create-react-class',
      'recompose',
      'react-dom',
      'react-redux',
      'redux',
      'redux-thunk',
      'immutable',

      '@material-ui/core',
      '@material-ui/icons',
      '@material-ui/docs',
      'react-swipeable-views',

      'change-emitter',
      'core-js',

      //'typeface-roboto',  // FIXME
    ],

    main_lib: [
      'fast-sha256',
      'jszip',
    ],
  },
  output: {
    path: path.resolve(__dirname, '../xpi/js'),
    filename: '[name].js',
    library: '[name]_[hash]',
  },

  mode: 'development',
};
