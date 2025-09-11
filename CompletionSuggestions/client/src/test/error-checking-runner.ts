/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
import * as path from "path";
import * as Mocha from "mocha";
import * as glob from "glob";

export function run(): Promise<void> {
  // Create the mocha test
  const mocha = new Mocha({
    ui: "bdd",
    color: true,
  });
  mocha.timeout(100000);

  const testsRoot = path.resolve(__dirname, "e2e/error-checking");
  console.log("Tests Root: ", testsRoot);
  // const testFiles = glob.sync("**.test.js", { cwd: testsRoot });
  const testFiles = glob.sync("error-check.test.js", { cwd: testsRoot });
  console.log("Test Files: ", testFiles);

  return new Promise((resolve, reject) => {
    // Add files to the test suite
    testFiles.forEach((f) => mocha.addFile(path.resolve(testsRoot, f)));

    try {
      // Run the mocha test
      mocha.run((failures) => {
        if (failures > 0) {
          reject(new Error(`${failures} tests failed.`));
        } else {
          resolve();
        }
      });
    } catch (err) {
      console.error(err);
      reject(err);
    }
  });
}
