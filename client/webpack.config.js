const path = require('path');

module.exports = {
  mode: 'production',
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    // Output straight into server/public, so the same "public is a
    // sibling of server.js" assumption holds true both locally and in Docker.
    path: path.resolve(__dirname, '../server/public'),
    clean: true, // wipes old bundle.js/index.html before each build
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.(png|jpe?g|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8192,
            },
          },
        ],
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: 'babel-loader',
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.css', '.png'],
  },
  plugins: [
    new (require('html-webpack-plugin'))({
      template: './src/index.html',
      filename: 'index.html',
    }),
  ],
};
