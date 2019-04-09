const path = require('path');
const ConcatPlugin = require('webpack-concat-plugin');

module.exports = (env) => {
  return {
    entry: './inventory.js',
    output: {
      filename: '-',
      path: path.resolve(__dirname, '../dist'),
    },
    plugins: [
      new ConcatPlugin({
        uglify: env == "production" ? true : false,
        sourceMap: false,
        name: 'result',
        outputPath: "/",
        fileName: 'inventory-bundle.js',
        filesToConcat: [
            path.resolve(__dirname, './inventory.config.js'),
            path.resolve(__dirname, './inventory.helper.js'),
            path.resolve(__dirname, './inventory.model.js'),
            path.resolve(__dirname, './inventory.view.js'),
            path.resolve(__dirname, './inventory.controller.js'),
            path.resolve(__dirname, './inventory.bootstrap.js'),
            path.resolve(__dirname, './inventory.js'),
        ],
        attributes: {
            async: true
        }
      })
    ]
  };
}