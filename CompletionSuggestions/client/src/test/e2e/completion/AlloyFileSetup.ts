import * as vscode from "vscode";
import * as assert from "assert";
import { activate } from "../../../utilities/helper";
import {
  testCompletion,
  COMPLETION_TERMS,
  getCompletionOffsets,
  getExpectedCompletionTerm,
  CompletionOffset,
  testSuggestionImpact,
  evaluateSuggestions,
} from "../../completion-utils";

import * as fs from "fs";
import * as path from "path";

export enum EXPORT_MODE {
  "file",
  "console",
}

export enum TEST_VARIANT {
  "single_term",
  "multi_term",
}

import {
  CompletionResultExportUtils,
  SuggestionImpactExportUtils,
} from "./resultExportUtils";
import { EvaluateSuggestionParams } from "../../../interfaces/commands";
import { log } from "console";

const RESULT_MODE: EXPORT_MODE[] = [EXPORT_MODE.file];
const CLEAR_RESULTS = true;
const IGNORE_TRUE_CASES = false;

const rootOfProject = path.resolve(__dirname, "../../../../../");
var OUTPUT_TEST_DIR = path.join(rootOfProject, "test-results/formula");
if (process.env["GENERATOR_COMPLETION"] === "true") {
  OUTPUT_TEST_DIR = path.join(rootOfProject, "test-results/generator");
}

export class AlloyFileSetup {
  public name: string;
  private sigOnlyFileUri: vscode.Uri;
  private completeFileUri: vscode.Uri;

  private _sigDocumentText: string;
  private _completeDocumentText: string;

  private _sigDocumentOffsets: CompletionOffset[];
  private _completeDocumentOffsets: CompletionOffset[];

  private _modelDir: string;
  private _variant: TEST_VARIANT;
  private _testDir: string;

  constructor(
    name: string,
    sigOnlyFileUri: vscode.Uri | undefined,
    completeFileUri: vscode.Uri
  ) {
    this.name = name;
    this.sigOnlyFileUri = sigOnlyFileUri;
    this.completeFileUri = completeFileUri;
    // this._variant = variant;
    // this._testDir = `${BASE_TEST_DIR}/${TEST_VARIANT[variant]}`;

    let sigOffset = 0;

    if (sigOnlyFileUri) {
      this._sigDocumentText = fs.readFileSync(sigOnlyFileUri.fsPath, "utf-8");
      this._sigDocumentOffsets = getCompletionOffsets(
        this._sigDocumentText,
        COMPLETION_TERMS
      );

      sigOffset = this._sigDocumentText.length;
    }

    this._completeDocumentText = fs.readFileSync(
      completeFileUri.fsPath,
      "utf-8"
    );
    this._completeDocumentOffsets = getCompletionOffsets(
      this._completeDocumentText,
      COMPLETION_TERMS,
      sigOffset
    );

    this._modelDir = `${this._testDir}/${name}`;
  }

  private _prepareDocument = async (doc: vscode.Uri) => {
    await activate(doc);
    const document = await vscode.workspace.openTextDocument(doc);
    await vscode.window.showTextDocument(document);
  };

  private _testCompletionAtOffset = (
    offset: CompletionOffset,
    documentUri: vscode.Uri,
    documentText: string,
    variant: TEST_VARIANT
  ) => {
    return async () => {
      const editor = vscode.window.activeTextEditor;
      const offsetPosition = editor.document.positionAt(offset.offset);
      const regex = /[~*^()]\w+/;
      const nextWordRange = editor.document.getWordRangeAtPosition(
        offsetPosition
      );
      //TODO: add remaining line text
      const expectedCompletion = nextWordRange
        ? editor.document.getText(nextWordRange)
        : getExpectedCompletionTerm(
            documentText,
            offset.offset,
            variant === TEST_VARIANT.single_term
          );
      const line = editor.document.lineAt(offsetPosition);
      const selection = new vscode.Selection(offsetPosition, line.range.end);
      const removableText = editor.document.getText(selection);
      editor.edit((editBuilder) => {
        editBuilder.replace(selection, "");
      });

      await editor.document.save();
      // await new Promise((resolve) => setTimeout(resolve, 100));

      const incompleteText = editor.document.getText();
      const incompleteLine = editor.document.lineAt(offsetPosition).text;

      const { result: completionList, elapsedTimeInMs } =
        await this.measureTime(() =>
          testCompletion(documentUri, offsetPosition)
        );

      assert.ok(completionList.items.length >= 0);

      const suggestionEvaluationParams: EvaluateSuggestionParams = {
        position: offsetPosition,
        incompleteExpression: incompleteLine,
        expectedTerm: expectedCompletion,
        remainingText: removableText,
        suggestions: completionList.items.map((item) => item.label.toString()),
      };

      const evaluationResult = await evaluateSuggestions(
        suggestionEvaluationParams
      );
      // console.log("Evaluation Result: ", evaluationResult);

      const { result: suggestionImpactList, elapsedTimeInMs: impactTime } =
        await this.measureTime(async () => {
          return await Promise.all(
            completionList.items.map(async (item) => {
              try {
                return await testSuggestionImpact(
                  documentUri,
                  incompleteLine,
                  item.label.toString(),
                  offsetPosition
                );
              } catch (error) {
                console.error(
                  `Error testing suggestion impact for item ${item.label}:`,
                  error
                );
                return null;
              }
            })
          );
        });

      // Restore the document to its original state
      editor.edit((editBuilder) => {
        editBuilder.insert(offsetPosition, removableText);
      });
      await editor.document.save();
      const completionResultExportUtils = new CompletionResultExportUtils();
      completionResultExportUtils.expResult(
        this.name,
        editor.document.fileName,
        offset,
        offsetPosition,
        incompleteText,
        incompleteLine,
        removableText,
        completionList,
        evaluationResult,
        expectedCompletion,
        elapsedTimeInMs,
        variant
      );
      // 1 sec timeout
      // await new Promise((resolve) => setTimeout(resolve, 1000));
      // Export suggestion impacts as CSV
      const suggestionImpactExporter = new SuggestionImpactExportUtils();
      await suggestionImpactExporter.expResult(
        this.name,
        editor.document.fileName,
        offset,
        offsetPosition,
        incompleteLine,
        removableText,
        impactTime,
        suggestionImpactList.filter(Boolean) // filter out nulls
      );
    };
  };

  public async runMultiTermTests() {
    // this._variant = TEST_VARIANT.multi_term;
    this._testDir = `${OUTPUT_TEST_DIR}/${
      TEST_VARIANT[TEST_VARIANT.multi_term]
    }`;
    this._modelDir = `${this._testDir}/${this.name}`;
    await this.runTests(TEST_VARIANT.multi_term);
  }

  public async runTests(variant: TEST_VARIANT) {
    // const sigOnlyDoc = getDocUri(this.sigOnlyFileUri);
    // const completeDoc = getDocUri(this.completeFileUri);
    describe(`${this.name} completion`, () => {
      before(async () => {
        // delete the test results directory
        const modelDir = `${OUTPUT_TEST_DIR}/${TEST_VARIANT[variant]}/${this.name}`;
        if (CLEAR_RESULTS && fs.existsSync(modelDir)) {
          fs.rmdirSync(modelDir, { recursive: true });
        }
      });
      if (this.sigOnlyFileUri) {
        describe("for sig only part", () => {
          before(async () => {
            console.log("Opening sig only file...");
            await this._prepareDocument(this.sigOnlyFileUri);
          });
          for (const offset of this._sigDocumentOffsets) {
            it(
              `Completes suggestion for offset ${offset.offset}`,
              this._testCompletionAtOffset(
                offset,
                this.sigOnlyFileUri,
                this._sigDocumentText,
                variant
              )
            );
          }

          after(async () => {
            console.log("Closing sig only file...");
            await vscode.commands.executeCommand(
              "workbench.action.closeActiveEditor"
            );
          });
        });
      }

      describe("for complete part", () => {
        before(async () => {
          console.log("Opening complete file...");
          await this._prepareDocument(this.completeFileUri);
        });
        for (const offset of this._completeDocumentOffsets) {
          it(
            `Completes suggestion for offset ${offset.offset}`,
            this._testCompletionAtOffset(
              offset,
              this.completeFileUri,
              this._completeDocumentText,
              variant
            )
          );
        }

        after(async () => {
          console.log("Closing complete file...");
          await vscode.commands.executeCommand(
            "workbench.action.closeActiveEditor"
          );
        });
      });
    });
  }
  private async measureTime<T>(
    asyncFn: () => Promise<T>
  ): Promise<{ result: T; elapsedTimeInMs: number }> {
    const start = process.hrtime.bigint();
    const result = await asyncFn();
    const end = process.hrtime.bigint();
    return { result, elapsedTimeInMs: Number(end - start) / 1e6 };
  }
}
