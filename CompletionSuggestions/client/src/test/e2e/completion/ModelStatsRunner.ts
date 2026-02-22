import * as vscode from "vscode";
import { activate } from "../../../utilities/helper";
import { ModelStatsRecord } from "./modelStatsExportUtils";

interface ModelStatsResponse {
  numSignatures: number;
  numRelations: number;
  numFunctions: number;
  numFacts: number;
  numPredicates: number;
  numAssertions: number;
  numCommands: number;
  numOfFormulas: number;
}

export class ModelStatsRunner {
  public name: string;
  private completeFileUri: vscode.Uri;

  constructor(name: string, completeFileUri: vscode.Uri) {
    this.name = name;
    this.completeFileUri = completeFileUri;
  }

  private _prepareDocument = async (doc: vscode.Uri) => {
    await activate(doc);
    const document = await vscode.workspace.openTextDocument(doc);
    await vscode.window.showTextDocument(document);
  };

  public runModelStatsTests(recordCollector: (record: ModelStatsRecord) => void) {
    describe(`${this.name} model stats`, () => {
      before(async () => {
        console.log("Opening complete file...");
        await this._prepareDocument(this.completeFileUri);
      });

      it("collects model stats", async () => {
        try {
          const editor = vscode.window.activeTextEditor;
          if (!editor) {
            console.warn(`Skipping ${this.name}: no active editor`);
            return;
          }

          const stats = (await vscode.commands.executeCommand(
            "alloy.getModelStats"
          )) as ModelStatsResponse | undefined;

          if (!stats) {
            console.warn(`Skipping ${this.name}: no stats returned`);
            return;
          }

          const filename = editor.document.fileName
            .split("/testFixture/")
            .pop();

          recordCollector({
            modelName: this.name,
            filename: filename ?? editor.document.fileName,
            numSignatures: stats.numSignatures,
            numRelations: stats.numRelations,
            numFunctions: stats.numFunctions,
            numFacts: stats.numFacts,
            numPredicates: stats.numPredicates,
            numAssertions: stats.numAssertions,
            numCommands: stats.numCommands,
            numOfFormulas: stats.numOfFormulas,
          });
        } catch (error) {
          console.warn(`Skipping ${this.name}: ${error}`);
        }
      });

      after(async () => {
        console.log("Closing complete file...");
        await vscode.commands.executeCommand(
          "workbench.action.closeActiveEditor"
        );
      });
    });
  }
}
