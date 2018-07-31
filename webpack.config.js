// webpack.config.js, pdso/
const path = require('path');

const webpack = require('webpack');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;


// the common config
function _common() {
  return {
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
    resolve: {
      extensions: [
        '.js',
        '.coffee',
      ],
    },

    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, 'xpi/js'),
    },

    // add this to avoid `eval()`
    devtool: 'source_map',
    mode: 'production',
  };
}

function _plugin_dllref(name) {
  return new webpack.DllReferencePlugin({
    context: __dirname,
    // build/manifest-[name]_lib.json
    manifest: require('./build/manifest-' + name + '_lib.json'),
  });
}

function _plugin_bundle_analyzer(name) {
  return new BundleAnalyzerPlugin({
    analyzerMode: 'disabled',
    generateStatsFile: true,
    // FIXME remove these files in production
    // xpi/js/profile_[name].json
    statsFilename: 'profile_' + name + '.json',
  });
}

function _plugin2(name) {
  return [
    _plugin_dllref(name),
    _plugin_bundle_analyzer(name),
  ];
}


// targets for use different dll libs
const targets = [
  // use ui_lib and ui-icon_lib
  {
    name: 'ui',
    plugins: [
      _plugin_dllref('ui_icon'),
      _plugin_dllref('ui'),  // `ui` after `ui_icon`: order is important !
      _plugin_bundle_analyzer('ui'),
    ],
    entry: {
      options: './src/options.coffee',
      popup: './src/popup.coffee',
    },
  },
  // use main_lib
  {
    name: 'main',
    plugins: _plugin2('main'),
    entry: {
      main: './src/main.coffee',
    },
  },
  // use content_lib
  {
    name: 'contents',
    plugins: _plugin2('content'),
    entry: {
      contents: './src/contents.coffee',
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
