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
import { EvaluateSuggestionParams } from "./interfaces/commands";

let client: LanguageClient;

const serverDebug = process.env["SERVER_DEBUG"] === "true" || false;
export async function activate(context: vscode.ExtensionContext) {
  let serverRunner = new ServerRunner(context);

  // Get the server options (this will check the port and start the server if necessary)
  let serverOptions: ServerOptions;
  try {
    if (serverDebug) {
      serverOptions = await serverRunner.getNoSpawnSocketServerOptions();
    } else {
      serverOptions = await serverRunner.getStdioServerOptions();
    }
  } catch (error) {
    console.error("Failed to get server options or start the server:", error);
    return;
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
    clientOptions
  );

  client.onNotification("alloy/updateModel", (message) => {
    console.log("Notification received: " + message);
  });

  // Register commands and other features
  const instanceViewCommand = vscode.commands.registerCommand(
    "alloy.showInstance",
    () => {
      AlloyInstanceDiagram.render(context.extensionUri);
    }
  );

  const runCommandCommandDisposable = vscode.commands.registerCommand(
    "alloy.runCommand",
    showInstanceCommandHandler(client, context)
  );

  const showNextInstanceCommandDisposable = vscode.commands.registerCommand(
    "alloy.nextInstance",
    showNextInstanceCommandHandler(client, context)
  );

  const showLegacyViewCommandDisposable = vscode.commands.registerCommand(
    "alloy.showLegacyView",
    showLegacyViewCommandHandler(client)
  );

  const suggestionImpactCommandDisposable = vscode.commands.registerCommand(
    "alloy.suggestionImpact",
    completionSuggestionImpactHandler(client, context)
  );

  const evaluateSuggestionCommandDisposable = vscode.commands.registerCommand(
    "alloy.evaluateSuggestions",
    evaluateSuggestionCommandHandler(client, context)
  );

  const getModelStatsCommandDisposable = vscode.commands.registerCommand(
    "alloy.getModelStats",
    getModelStatsCommandHandler(client, context)
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
                context.selectedCompletionInfo.text.replace("^", "^^")
              )
            );
          }
          return items;
        } else {
          return [];
        }
      },
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

  context.subscriptions.push(
    instanceViewCommand,
    showNextInstanceCommandDisposable,
    showLegacyViewCommandDisposable,
    runCommandCommandDisposable,
    inlineCompletionItemDisposable,
    suggestionImpactCommandDisposable,
    evaluateSuggestionCommandDisposable,
    getModelStatsCommandDisposable
  );
}

export function deactivate(): Thenable<void> | undefined {
  if (!client) {
    return undefined;
  }
  return client.stop();
}
