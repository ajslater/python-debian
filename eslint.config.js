import { FlatCompat } from "@eslint/eslintrc";
import js from "@eslint/js";
import markdown from "eslint-plugin-markdown";
import eslintPluginToml from "eslint-plugin-toml";
import globals from "globals";

const compat = new FlatCompat();

export default [
  {
    languageOptions: {
      globals: {
        ...globals.node,
      },
    },
    linterOptions: {
      reportUnusedDisableDirectives: "warn",
    },
    plugins: {
      markdown: markdown,
    },
  },
  ...markdown.configs.recommended,
  ...eslintPluginToml.configs["flat/recommended"],
  js.configs.recommended,
  {
    files: ["**/*.md"],
    processor: "markdown/markdown",
    rules: {
      "prettier/prettier": ["warn", { parser: "markdown" }],
    },
  },
  {
    files: ["**/*.md/*.js"], // Will match js code inside *.md files
    rules: {
      "no-unused-vars": "off",
      "no-undef": "off",
    },
  },
  {
    files: ["**/*.md/*.sh"],
    rules: {
      "prettier/prettier": ["error", { parser: "sh" }],
    },
  },
  ...compat.config({
    root: true,
    env: {
      browser: true,
      es2024: true,
      node: true,
    },
    extends: [
      // LANGS
      "plugin:jsonc/recommended-with-json",
      "plugin:jsonc/prettier",
      "plugin:yml/standard",
      "plugin:yml/prettier",
      // PRETTIER
      "plugin:prettier/recommended",
    ],
    overrides: [
      {
        files: ["*.toml"],
        // parser: "toml-eslint-parser",
        rules: {
          "prettier/prettier": ["error", { parser: "toml" }],
        },
      },
      {
        files: ["*.json", "*.json5", "*.jsonc"],
        parser: "jsonc-eslint-parser",
        //rules: {
        //  "prettier/prettier": ["error", { parser: "json" }],
        //},
      },
      {
        files: ["docker-compose*.yaml"],
        rules: {
          "yml/no-empty-mapping-value": "off",
        },
      },
    ],
    parserOptions: {
      ecmaFeatures: {
        impliedStrict: true,
      },
      ecmaVersion: "latest",
    },
    plugins: ["markdown"],
    rules: {
      "prettier/prettier": [
        "warn",
        {
          trailingComma: "all",
        },
      ],
    },
    ignorePatterns: [
      "*~",
      ".git",
      "!.circleci",
      ".venv*",
      "node_modules",
      "package-lock.json",
      "poetry.lock",
    ],
  }),
];
