import { fileURLToPath } from "url";
import { dirname, resolve as _resolve } from "path";
import ForkTsCheckerWebpackPlugin from "fork-ts-checker-webpack-plugin";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const isProduction = process.env.NODE_ENV == "production";

const config = {
  entry: "./src/init.ts",
  output: {
    path: _resolve(__dirname, "dist/dol-languages-mod/"),
    filename: "translationsLoader.js",
  },
  devtool: "inline-source-map",
  target: "web",
  plugins: [
    new ForkTsCheckerWebpackPlugin({
      typescript: {
        configFile: "tsconfig.json",
        memoryLimit: 4096,
      },
    }),
  ],
  module: {
    rules: [
      {
        use: "ts-loader",
        test: /\.(ts|tsx)$/i,
        exclude: ["/node_modules/"],
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2|png|jpg|gif)$/i,
        type: "asset",
      },
      {
        resourceQuery: /inlineText/,
        type: "asset/source",
      },
    ],
  },
  resolve: {
    extensions: [".tsx", ".ts", ".jsx", ".js", "..."],
    alias: {},
    fallback: {
      crypto: false,
    },
  },
};

export default () => {
  if (isProduction) {
    config.mode = "production";
  } else {
    config.mode = "development";
  }
  return config;
};
