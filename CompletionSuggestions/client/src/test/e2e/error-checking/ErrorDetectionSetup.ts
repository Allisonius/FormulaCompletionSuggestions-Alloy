import { ErrorChecker } from "./ErrorCheckSetup";
import { getDocUri } from "../../../utilities/helper";
import * as vscode from "vscode";
import * as fs from "fs";
import * as path from "path";
import { assert } from "console";

export interface ErrorData {
  file: string;
  modelName: string;
  errorMessage: string;
  errorLevel: string;
  elapsedTimeInMs: number;
  errorType: "SYNTAX" | "TYPE";
}

export class ErrorTester {
  private testDoc: vscode.Uri;
  private setup: ErrorChecker;
  private errorData: ErrorData[] = [];
  private totalFiles: number = 0;
  private totalErrors: number = 0;
  private modelName: string;
  private errorType: "SYNTAX" | "TYPE";
  private testFileDir: string;
  private resultsDir: string;

  constructor(
    testDocPath: string,
    modelName: string,
    errorType: "SYNTAX" | "TYPE",
    testFileDir: string,
    resultsDir: string
  ) {
    this.testDoc = getDocUri(testDocPath);
    this.setup = new ErrorChecker(this.testDoc);
    this.modelName = modelName;
    this.errorType = errorType;
    this.testFileDir = testFileDir;
    this.resultsDir = resultsDir;
    console.log(`Initialized ErrorTester with doc: ${this.testDoc}`);
  }

  private getAllFiles(dirPath: string, arrayOfFiles: string[] = []): string[] {
    const workspacePath = vscode.workspace.workspaceFolders[0].uri.path;
    dirPath = path.join(workspacePath, dirPath);
    const directory = vscode.Uri.file(dirPath);
    const files = fs.readdirSync(directory.path);

    files.forEach((file) => {
      if (fs.statSync(path.join(dirPath, file)).isDirectory()) {
        arrayOfFiles = this.getAllFiles(path.join(dirPath, file), arrayOfFiles);
      } else {
        arrayOfFiles.push(path.join(dirPath, file));
      }
    });
    return arrayOfFiles;
  }

  public writeToCSV(): void {
    // Create CSV header row
    // const header =
    //   "file,modelName,errorMessage,errorLevel,elapsedTimeInMs,errorType\n";
    const header =
      "modelName,errorMessage,errorLevel,elapsedTimeInMs,errorType\n";

    // Convert each data item to CSV row
    const rows = this.errorData
      .map((item) => {
        // Escape quotes in strings to avoid CSV parsing issues
        const escapedErrorMessage = item.errorMessage.replace(/"/g, '""');

        return `"${item.modelName}","${escapedErrorMessage}","${item.errorLevel}",${item.elapsedTimeInMs},"${item.errorType}"`;
      })
      .join("\n");

    // Combine header and rows
    const csvContent = header + rows;

    // Write to file
    try {
      const fileName = path.join(
        this.resultsDir,
        `${this.modelName}-${this.errorType.toLowerCase()}_errors.csv`
      );
      fs.writeFileSync(fileName, csvContent, "utf8");
      console.log(`Successfully wrote to ${fileName}`);
    } catch (err) {
      console.error(`Error writing to CSV file: ${err}`);
    }
  }

  public async runTests(): Promise<void> {
    const files = this.getAllFiles(this.testFileDir);
    this.totalFiles = files.length;
    console.log(`Total files to test: ${this.totalFiles}`);

    // Set up describe block
    describe(`${this.errorType} error checking`, () => {
      for (const file of files) {
        describe(`${this.errorType} errors for ${file}`, () => {
          before(async () => {
            console.log(`Testing ${file}`);
          });

          it(`should return errors`, async () => {
            const content = fs.readFileSync(file, "utf-8");
            const diagnostics = await this.setup.getDiagnostics(content);
            assert(diagnostics.length > 0);

            if (diagnostics.length > 0) {
              this.totalErrors += 1;
              this.errorData.push({
                file: file,
                modelName: this.modelName,
                errorMessage: diagnostics[0].message,
                errorLevel: diagnostics[0].type,
                elapsedTimeInMs: Number(diagnostics[0].elapsedTimeInMs),
                errorType: this.errorType,
              });
            }
          });

          after(async () => {
            console.log(`Finished testing ${file}`);
          });
        });
      }

      after(() => {
        console.log("Tests finished");
        console.log(`Total files: ${this.totalFiles}`);
        console.log(`Total errors: ${this.totalErrors}`);
        console.log(
          `Error rate: ${(this.totalErrors / this.totalFiles) * 100}%`
        );
      });
    });
  }

  public get results(): {
    errorData: ErrorData[];
    totalFiles: number;
    totalErrors: number;
    errorRate: number;
  } {
    return {
      errorData: this.errorData,
      totalFiles: this.totalFiles,
      totalErrors: this.totalErrors,
      errorRate: (this.totalErrors / this.totalFiles) * 100,
    };
  }
}
