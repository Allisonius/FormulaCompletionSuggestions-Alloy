import * as vscode from "vscode";
import { LanguageClient } from "vscode-languageclient/node";
import { AlloyInstanceDiagram } from "./panels/AlloyInstanceDiagram";
import { EvaluateSuggestionParams } from "./interfaces/commands";

export const showLegacyViewCommandHandler = (client: LanguageClient) => {
  return async (alloyCommand: string, isNextInstance: boolean | null) => {
    /*
      This will send a request to the server to show the legacy view
      The server will spawn a new window to show the legacy view
      No response is expected from the server
      */
    const editor = vscode.window.activeTextEditor;
    if (editor) {
      const command = alloyCommand || "Run {} for 3";
      const documentUri = editor.document.uri.toString();
      const request = {
        documentUri: documentUri,
        command: command,
      };
      if (isNextInstance) {
        request["isNextInstance"] = isNextInstance;
      }
      client.sendRequest("alloy/legacyVizViewer", request);
    }
  };
};

export const showInstanceCommandHandler = (
  client: LanguageClient,
  context: vscode.ExtensionContext
) => {
  return async (alloyCommand: String | null) => {
    const editor = vscode.window.activeTextEditor;
    if (editor) {
      const documentUri = editor.document.uri.toString();
      const response = client.sendRequest("alloy/getInstance", {
        documentUri: documentUri,
        command: alloyCommand,
      });
      response.then((result) => {
        const data = {
          alloyCommand: alloyCommand,
          instanceData: JSON.stringify(result),
        };
        AlloyInstanceDiagram.render(context.extensionUri);
        AlloyInstanceDiagram.postMessage({
          eventType: "react:showInstance",
          body: data,
        });
      });
    }
  };
};

export const showNextInstanceCommandHandler = (
  client: LanguageClient,
  context: vscode.ExtensionContext
) => {
  return async () => {
    const editor = vscode.window.activeTextEditor;
    if (editor) {
      const documentUri = editor.document.uri.toString();
      const response = client.sendRequest("alloy/nextInstance", {
        documentUri: documentUri,
      });
      response.then((result) => {
        const data = {
          // alloyCommand: alloyCommand,
          instanceData: JSON.stringify(result),
        };
        AlloyInstanceDiagram.render(context.extensionUri);
        AlloyInstanceDiagram.postMessage({
          eventType: "react:nextInstance",
          body: data,
        });
      });
    }
  };
};


export const completionSuggestionImpactHandler = (
  client: LanguageClient,
  context: vscode.ExtensionContext
) => {
  return async (suggestion: string, incompletionFormula: string, position: vscode.Position) => {
    const editor = vscode.window.activeTextEditor;
    if (editor) {
      const documentUri = editor.document.uri.toString();
      return await client.sendRequest("alloy/suggestionImpact", {
        documentUri: documentUri,
        incompleteFormula: incompletionFormula,
        suggestion: suggestion,
        position: position
      });
    }
  };
}

export const evaluateSuggestionCommandHandler = (
    client: LanguageClient,
    context: vscode.ExtensionContext
  ) => {
    return async (params: EvaluateSuggestionParams) => {
      const editor = vscode.window.activeTextEditor;
      if (editor) {
        const documentUri = editor.document.uri.toString();
        return await client.sendRequest("alloy/evaluateSuggestions", {
          documentUri: documentUri,
          ...params
        });
      }
    };
};    