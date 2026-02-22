import * as vscode from "vscode";
import { activate } from "../../../utilities/helper";
import { evaluateSuggestions } from "../../completion-utils";

import * as fs from "fs";
import * as path from "path";

import { EvaluateSuggestionParams } from "../../../interfaces/commands";

const rootOfProject = path.resolve(__dirname, "../../../../../");
var TEST_DATA_DIR = path.join(rootOfProject, "test-results/formula/multi_term");
if (process.env["GENERATOR_COMPLETION"] === "true") {
  TEST_DATA_DIR = path.join(rootOfProject, "test-results/generator/multi_term");
}
if (process.env["LLM_COMPLETION"] === "true") {
  TEST_DATA_DIR = path.join(rootOfProject, "test-results/llm/multi_term");
}

export class EvaluateSuggestions {
  private name: string;
  private completeFileUri: vscode.Uri;

  constructor(name: string, completeFileUri: vscode.Uri) {
    this.name = name;
    this.completeFileUri = completeFileUri;
  }

  public importResultFiles(modelName: string): string[] {
    const jsonFiles: string[] = [];
    const modelDir = `${TEST_DATA_DIR}/${modelName}`;
    if (!fs.existsSync(modelDir)) {
      return jsonFiles;
    }

    const walkDir = (dir: string) => {
      const files = fs.readdirSync(dir);

      files.forEach((file) => {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
          walkDir(fullPath);
        } else if (path.extname(file) === ".json") {
          jsonFiles.push(fullPath);
        }
      });
    };
    walkDir(modelDir);
    return jsonFiles;
  }

  private _prepareDocument = async (doc: vscode.Uri) => {
    await activate(doc);
    const document = await vscode.workspace.openTextDocument(doc);
    await vscode.window.showTextDocument(document);
  };

  public async updateEvaluationResults(resultsFilePath: string): Promise<void> {
    const data = fs.readFileSync(resultsFilePath, "utf-8");
    const parsedData = JSON.parse(data);
    const suggestionEvaluationParams: EvaluateSuggestionParams = {
      position: new vscode.Position(parsedData.line - 1, parsedData.character),
      incompleteExpression: parsedData.incompletionLine,
      expectedTerm: parsedData.expectedCompletionWord,
      remainingText: parsedData.expectedCompletionLine,
      suggestions: parsedData.completionList
        .split(",")
        .map((item: string) => item.trim()),
    };
    const evaluationResult = await evaluateSuggestions(
      suggestionEvaluationParams,
    );
    parsedData.evaluationResult = evaluationResult.evaluations;
    fs.writeFileSync(
      resultsFilePath,
      JSON.stringify(parsedData, null, 2),
      "utf-8",
    );
  }

  public async runEvaluation(): Promise<void> {
    describe(`${this.name} suggestion evaluation`, () => {
      describe("for complete part", () => {
        before(async () => {
          console.log("Opening complete file...");
          await this._prepareDocument(this.completeFileUri);
        });

        const results = this.importResultFiles(this.name);
        for (const jsonFile of results) {
          it(`should evaluate suggestions for ${jsonFile}`, async () => {
            await this.updateEvaluationResults(jsonFile);
          });
        }

        after(async () => {
          console.log("Closing complete file...");
          await vscode.commands.executeCommand(
            "workbench.action.closeActiveEditor",
          );
        });
      });
    });
  }
}
