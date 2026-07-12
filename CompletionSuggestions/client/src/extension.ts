/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
import * as vscode from "vscode";
// import { socketServerConnection } from "./server-connection";
import ServerRunner from "./server-opts";

import { AlloyInstanceDiagram } from "./panels/AlloyInstanceDiagram";

import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
} from "vscode-languageclient/node";

import {
  showLegacyViewCommandHandler,
  showInstanceCommandHandler,
  showNextInstanceCommandHandler,
  completionSuggestionImpactHandler,
  evaluateSuggestionCommandHandler,
  getModelStatsCommandHandler,
} from "./commands-handlers";

let client: LanguageClient;

const serverDebug = process.env["SERVER_DEBUG"] === "true" || false;
export async function activate(context: vscode.ExtensionContext) {
  let serverRunner = new ServerRunner(context);

  // Server setup is attempted first, but failures must not prevent command registration.
  // Commands are always registered so VS Code can find them regardless of server state.
  try {
    let serverOptions: ServerOptions;
    if (serverDebug) {
      serverOptions = await serverRunner.getNoSpawnSocketServerOptions();
    } else {
      serverOptions = await serverRunner.getStdioServerOptions();
    }

    const clientOptions: LanguageClientOptions = {
      documentSelector: [{ scheme: "file", language: "alloy" }],
      synchronize: {
        fileEvents: vscode.workspace.createFileSystemWatcher("**/*.als"),
      },
    };

    client = new LanguageClient(
      "alloy",
      "Alloy Language Server",
      serverOptions,
      clientOptions,
    );

    client.onNotification("alloy/updateModel", (message) => {
      console.log("Notification received: " + message);
    });

    // Start the client. This will also launch the server
    client
      .start()
      .then(() => {
        console.log("Client started");
      })
      .catch((error) => {
        console.error("Failed to start the client:", error);
      });

    console.log('"Alloy Language Extension" is now active!');
  } catch (error) {
    console.error("Failed to get server options or start the server:", error);
  }

  // Register commands unconditionally. Client-dependent handlers guard against
  // an uninitialized client at call time so the commands are always discoverable.
  const instanceViewCommand = vscode.commands.registerCommand(
    "alloy.showInstance",
    () => {
      AlloyInstanceDiagram.render(context.extensionUri);
    },
  );

  const runCommandCommandDisposable = vscode.commands.registerCommand(
    "alloy.runCommand",
    async (alloyCommand: string | null) => {
      if (!client) return null;
      return showInstanceCommandHandler(client, context)(alloyCommand);
    },
  );

  const showNextInstanceCommandDisposable = vscode.commands.registerCommand(
    "alloy.nextInstance",
    async () => {
      if (!client) return null;
      return showNextInstanceCommandHandler(client, context)();
    },
  );

  const showLegacyViewCommandDisposable = vscode.commands.registerCommand(
    "alloy.showLegacyView",
    async (alloyCommand: string, isNextInstance: boolean | null) => {
      if (!client) return null;
      return showLegacyViewCommandHandler(client)(alloyCommand, isNextInstance);
    },
  );

  const suggestionImpactCommandDisposable = vscode.commands.registerCommand(
    "alloy.suggestionImpact",
    async (suggestion: string, incompletionFormula: string, position: vscode.Position) => {
      if (!client) return null;
      return completionSuggestionImpactHandler(client, context)(suggestion, incompletionFormula, position);
    },
  );

  const evaluateSuggestionCommandDisposable = vscode.commands.registerCommand(
    "alloy.evaluateSuggestions",
    async (params) => {
      if (!client) return null;
      return evaluateSuggestionCommandHandler(client, context)(params);
    },
  );

  const getModelStatsCommandDisposable = vscode.commands.registerCommand(
    "alloy.getModelStats",
    async () => {
      if (!client) return null;
      return getModelStatsCommandHandler(client, context)();
    },
  );

  const inlineCompletionItemDisposable =
    vscode.languages.registerInlineCompletionItemProvider("alloy", {
      provideInlineCompletionItems(document, position, context, token) {
        console.log("Position: ", position);
        console.log("Context: ", context);
        if (context.selectedCompletionInfo) {
          console.log("Inline completion items requested");
          console.log("Document: ", document);
          console.log("Token: ", token);
          const items = new vscode.InlineCompletionList([]);
          if (context.selectedCompletionInfo.text.startsWith("^")) {
            items.items.push(
              new vscode.InlineCompletionItem(
                context.selectedCompletionInfo.text.replace("^", "^^"),
              ),
            );
          }
          return items;
        } else {
          return [];
        }
      },
    });

  context.subscriptions.push(
    instanceViewCommand,
    showNextInstanceCommandDisposable,
    showLegacyViewCommandDisposable,
    runCommandCommandDisposable,
    inlineCompletionItemDisposable,
    suggestionImpactCommandDisposable,
    evaluateSuggestionCommandDisposable,
    getModelStatsCommandDisposable,
  );
}

export function deactivate(): Thenable<void> | undefined {
  if (!client) {
    return undefined;
  }
  return client.stop();
}
