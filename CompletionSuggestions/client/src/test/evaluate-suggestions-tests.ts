/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
import * as path from "path";
import * as Mocha from "mocha";
import * as glob from "glob";

export function run(): Promise<void> {
  const mocha = new Mocha({
    ui: "bdd",
    color: true,
  });
  mocha.timeout(10000000);

  const testsRoot = path.resolve(__dirname, "e2e/completion");
  console.log("Tests Root: ", testsRoot);
  const testFiles = glob.sync("evaluate-suggestions.test.js", {
    cwd: testsRoot,
  });
  console.log("Test Files: ", testFiles);

  return new Promise((resolve, reject) => {
    testFiles.forEach((f) => mocha.addFile(path.resolve(testsRoot, f)));

    try {
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
