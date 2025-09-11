/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
import * as path from "path";
import * as Mocha from "mocha";

export function run(): Promise<void> {
  // Create the mocha test
  const mocha = new Mocha({
    ui: "bdd",
    color: true,
  });
  mocha.timeout(100000);

  //   const testsRoot = path.resolve(__dirname, "e2e");
  //   console.log("Tests Root: ", testsRoot);
  //   const testFiles = glob.sync("**.test.js", { cwd: testsRoot });
  //   console.log("Test Files: ", testFiles);

  const testFile = path.resolve(__dirname, "sample.test.js");

  return new Promise((resolve, reject) => {
    // Add files to the test suite
    mocha.addFile(testFile);

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
