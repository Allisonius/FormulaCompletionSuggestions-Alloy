import * as vscode from "vscode";
import * as assert from "assert";
import { activate } from "../../../utilities/helper";

export class ErrorChecker {
  private documentUri: vscode.Uri;
  private document: vscode.TextDocument;

  constructor(documentUri: vscode.Uri) {
    this.documentUri = documentUri;
  }

  private _prepareDocument = async (doc: vscode.Uri) => {
    await activate(doc);
    const document = await vscode.workspace.openTextDocument(doc);
    await vscode.window.showTextDocument(document);
    return document;
  };

  private async _editContent(content: string, document: vscode.TextDocument) {
    const editor = vscode.window.activeTextEditor;
    if (editor) {
      editor.edit((editBuilder) => {
        editBuilder.delete(
          new vscode.Range(
            document.positionAt(0),
            document.positionAt(document.getText().length)
          )
        );
        editBuilder.insert(new vscode.Position(0, 0), content);
      });
      await editor.document.save();
    }
  }

  public async getDiagnostics(
    content: string
  ): Promise<{ type: string; message: string }[]> {
    if (!this.document) {
      this.document = await this._prepareDocument(this.documentUri);
    }
    await this._editContent(content, this.document);
    // await new Promise((resolve) => setTimeout(resolve, 50));

    const startTime = process.hrtime.bigint();
    const diagnostics = vscode.languages.getDiagnostics(this.documentUri);
    const endTime = process.hrtime.bigint();
    const elapsedTimeInMs = Number(endTime - startTime) / 1e6;
    return diagnostics.map((diagnostic) => ({
      type: vscode.DiagnosticSeverity[diagnostic.severity],
      message: diagnostic.message,
      elapsedTimeInMs,
    }));
  }
}
