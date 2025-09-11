import * as vscode from "vscode";
import * as assert from "assert";
import * as path from "path";
import { getDocUri, activate } from "../utilities/helper";
import { testCompletion } from "./completion-utils";

describe("Triggering a completion", () => {
  const docUri = getDocUri("sample.als");
  console.log("DocUri: ", docUri);

  before(async () => {
    await activate(docUri);
    const document = await vscode.workspace.openTextDocument(docUri);
    await vscode.window.showTextDocument(document);
  });

  it("should generate completion list", async () => {
    // await new Promise((resolve) => setTimeout(resolve, 1000));
    const completionList: vscode.CompletionList = await testCompletion(
      docUri,
      // line number for vscode position starts at 1, put the exact line number for the sample.als file
      new vscode.Position(5, 20)
    );

    completionList.items.forEach((item) => {
      console.log(item.label + " " + item.detail);
    });

    console.log(completionList);

    // await new Promise((resolve) => setTimeout(resolve, 5000));
  });
});
