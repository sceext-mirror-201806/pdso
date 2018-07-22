// webpack.config.js, pdso/
const path = require('path');


module.exports = {
  module: {
    rules: [
      {  // coffeescript with React JSX
        test: /\.coffee$/,
        use: [
          {
            loader: 'coffee-loader',
          },
          // TODO
          //{
          //  loader: 'TODO',
          //},
        ],
      },
    ],
  },
  plugins: [
    // TODO
  ],
  resolve: {
    extensions: [
      '.js',
      '.coffee',
    ],
  },

  entry: {
    ui_lib: [
      'react',
      'react-dom',
      'react-redux',
      'redux',
      'redux-thunk',
      'immutable',

      '@material-ui/core',
      '@material-ui/icons',
      //'typeface-roboto',
    ],
    options: './src/options.coffee',
    popup: './src/popup.coffee',
    contents: './src/contents.coffee',

    main_lib: [
      'fast-sha256',
      'jszip',
    ],
    main: './src/main.coffee',
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'xpi/js'),
  },

  devtool: 'source_map',
  mode: 'development',
};
