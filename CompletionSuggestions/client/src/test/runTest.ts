/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import * as path from "path";

import { runTests } from "@vscode/test-electron";

async function main() {
  console.log("Starting e2e tests, args: ", process.argv);
  if (process.argv.length < 3) {
    try {
      // The folder containing the Extension Manifest package.json
      // Passed to `--extensionDevelopmentPath`
      const extensionDevelopmentPath = path.resolve(__dirname, "../../../");

      // The path to test runner
      // Passed to --extensionTestsPath
      // const extensionTestsPath = path.resolve(__dirname, "./index");

      const extensionTestsPath = path.resolve(__dirname, "./single-term-tests");
      const workspacePath = path.join(__dirname, "../../testFixture/");

      // await new Promise((resolve) => setTimeout(resolve, 10000));

      // Download VS Code, unzip it and run the integration test
      // await runServer("");
      await runTests({
        extensionDevelopmentPath,
        extensionTestsPath,
        launchArgs: [workspacePath],
      });
    } catch (err) {
      console.error("Failed to run single term tests", err);
      process.exit(1);
    }
  }
  if (process.argv[2] === "--formula-completion") {
    try {
      // The folder containing the Extension Manifest package.json
      // Passed to `--extensionDevelopmentPath`
      const extensionDevelopmentPath = path.resolve(__dirname, "../../../");

      // The path to test runner
      // Passed to --extensionTestsPath
      // const extensionTestsPath = path.resolve(__dirname, "./index");

      const extensionTestsPath = path.resolve(__dirname, "./multi-term-tests");
      const workspacePath = path.join(__dirname, "../../testFixture/");

      // await runServer("-m");
      // Download VS Code, unzip it and run the integration test
      await runTests({
        extensionDevelopmentPath,
        extensionTestsPath,
        launchArgs: [workspacePath],
      });
    } catch (err) {
      console.error("Failed to run multi term tests", err);
      process.exit(1);
    }
  }
  if (process.argv[2] === "--generator-completion") {
    try {
      // The folder containing the Extension Manifest package.json
      // Passed to `--extensionDevelopmentPath`
      const extensionDevelopmentPath = path.resolve(__dirname, "../../../");

      // The path to test runner
      // Passed to --extensionTestsPath
      // const extensionTestsPath = path.resolve(__dirname, "./index");

      const extensionTestsPath = path.resolve(__dirname, "./multi-term-tests");
      const workspacePath = path.join(__dirname, "../../testFixture/");

      // await runServer("-m");
      // Download VS Code, unzip it and run the integration test
      await runTests({
        extensionDevelopmentPath,
        extensionTestsPath,
        launchArgs: [workspacePath],
        extensionTestsEnv: {
          GENERATOR_COMPLETION: "true",
        },
      });
    } catch (err) {
      console.error("Failed to run multi term tests", err);
      process.exit(1);
    }
  }
  if (process.argv[2] === "--error-checking") {
    try {
      // The folder containing the Extension Manifest package.json
      // Passed to `--extensionDevelopmentPath`
      const extensionDevelopmentPath = path.resolve(__dirname, "../../../");

      // The path to test runner
      // Passed to --extensionTestsPath
      // const extensionTestsPath = path.resolve(__dirname, "./index");

      const extensionTestsPath = path.resolve(
        __dirname,
        "./error-checking-runner"
      );
      const workspacePath = path.join(__dirname, "../../testFixture/");

      // await runServer("-m");
      // Download VS Code, unzip it and run the integration test
      await runTests({
        extensionDevelopmentPath,
        extensionTestsPath,
        launchArgs: [workspacePath],
      });
    } catch (err) {
      console.error("Failed to run error checking tests", err);
      process.exit(1);
    }
  }
  process.exit(0);
}

main();
