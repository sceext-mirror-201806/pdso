// webpack-lib.config.js, pdso/build/
const path = require('path');

const webpack = require('webpack');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;


// the common config
function _common() {
  return {
    module: {
      rules: [
        {
          test: /\.css$/,
          loader: 'style-loader!css-loader',
        }
      ],
    },

    output: {
      path: path.resolve(__dirname, '../xpi/js'),
      filename: '[name].js',
      library: '[name]_[hash]',
    },

    mode: 'development',
  };
}

function _plugin_dll() {
  return new webpack.DllPlugin({
    name: '[name]_[hash]',
    path: path.resolve(__dirname, 'manifest-[name].json'),
  });
}

function _plugin_bundle_analyzer(name) {
  return new BundleAnalyzerPlugin({
    analyzerMode: 'disabled',
    generateStatsFile: true,
    // xpi/js/profile_[name].json
    statsFilename: 'profile_' + name + '.json',
  });
}

const targets = [
  // normal libs
  {
    name: 'lib',
    plugins: [
      _plugin_dll(),
      _plugin_bundle_analyzer('lib'),
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
        'react-swipeable-views',

        'change-emitter',
        'core-js',

        // for DEBUG
        'remote-redux-devtools',
      ],

      main_lib: [
        'fast-sha256',
        'jszip',
      ],

      content_lib: [
        'buffer',
        'jquery',
      ],
    },
  },
  // ui-icon_lib use ui_lib
  {
    name: 'ui_icon_lib',
    plugins: [
      // dll ref before dll plugin: order is important !
      new webpack.DllReferencePlugin({
        // context: root dir of this project (../)
        context: path.resolve(__dirname, '..'),
        // build/manifest-ui_lib.json
        manifest: require('./manifest-ui_lib.json'),
      }),
      _plugin_dll(),
      _plugin_bundle_analyzer('icon_lib'),
    ],
    entry: {
      ui_icon_lib: [
        '@material-ui/icons',
        'mdi-material-ui',

        //'typeface-roboto',  // FIXME
      ],
    },
  },
];


function _gen_config(targets, get_common) {
  const o = [];
  for (let i = 0; i < targets.length; i += 1) {
    const one = Object.assign(targets[i], get_common());
    o.push(one);
  }
  return o;
}

module.exports = _gen_config(targets, _common);
