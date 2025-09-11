import { ErrorChecker } from "./ErrorCheckSetup";
import { getDocUri } from "../../../utilities/helper";
import * as fs from "fs";
import * as path from "path";
import { assert, error } from "console";
import { get } from "http";
import { ErrorTester } from "./ErrorDetectionSetup";

const testDoc = getDocUri("error-checking/runner.als");
console.log(`opened doc: ${testDoc}`);

const PROJECT_ROOT_DIR = path.resolve(__dirname, "../../../../../");
const TEST_RESULTS_DIR = path.resolve(
  PROJECT_ROOT_DIR,
  "test-results",
  "error-checking"
);

class ErrorCheckingTestRunner {
  private runnerFile: string;
  private modelName: string;
  private testFileDir: string;
  private testResultsDir: string;

  constructor(runnerFile: string, modelName: string) {
    this.runnerFile = runnerFile;
    this.modelName = modelName;
    this.testFileDir = `error-checking/${modelName.toLowerCase()}`;
    this.testResultsDir = TEST_RESULTS_DIR;
  }

  async runTests() {
    describe(`Error checking for ${this.modelName}`, async () => {
      const syntaxTester = new ErrorTester(
        this.runnerFile,
        this.modelName,
        "SYNTAX",
        `${this.testFileDir}/syntax/`,
        this.testResultsDir
      );
      await syntaxTester.runTests();

      // Optionally write results to CSV after tests complete
      after(() => {
        syntaxTester.writeToCSV();
      });

      const typeTester = new ErrorTester(
        this.runnerFile,
        this.modelName,
        "TYPE",
        `${this.testFileDir}/type/`,
        this.testResultsDir
      );
      await typeTester.runTests();

      // Optionally write results to CSV after tests complete
      after(() => {
        typeTester.writeToCSV();
      });
    });
  }
}

// Create test runners for each model directory
// First model - classroom-fol
const classroomFol = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "classroom-fol"
);
classroomFol.runTests();

// Second model - classroom-rl
const classroomRL = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "classroom-rl"
);
classroomRL.runTests();

// Additional models
const coursesV1 = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "courses_v1"
);
coursesV1.runTests();

const coursesV2 = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "courses_v2"
);
coursesV2.runTests();

const cvV1 = new ErrorCheckingTestRunner("error-checking/runner.als", "cv_v1");
cvV1.runTests();

const cvV2 = new ErrorCheckingTestRunner("error-checking/runner.als", "cv_v2");
cvV2.runTests();

const graphs = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "graphs"
);
graphs.runTests();

const lts = new ErrorCheckingTestRunner("error-checking/runner.als", "lts");
lts.runTests();

const productionLineV1 = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "productionLine_v1"
);
productionLineV1.runTests();

const productionLineV2 = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "productionLine_v2"
);
productionLineV2.runTests();

const productionLineV3 = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "productionLine_v3"
);
productionLineV3.runTests();

const socialMedia = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "socialMedia"
);
socialMedia.runTests();

const trainStationFol = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "trainStation_fol"
);
trainStationFol.runTests();

const trainStationLtl = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "trainStation_ltl"
);
trainStationLtl.runTests();

const trashFol = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "trash_fol"
);
trashFol.runTests();

const trashLtl = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "trash_ltl"
);
trashLtl.runTests();

const trashRl = new ErrorCheckingTestRunner(
  "error-checking/runner.als",
  "trash_rl"
);
trashRl.runTests();
