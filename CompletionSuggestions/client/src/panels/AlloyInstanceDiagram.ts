import * as vscode from "vscode";
import { getUri } from "../utilities/getUri";
import { getNonce } from "../utilities/getNonce";
import * as extensionEvents from "../interfaces/extensionEvents";
import * as reactEvents from "../interfaces/reactEvents";
import { ExtensionEventMessage, ReactEventMessage } from "../interfaces/common";

export class AlloyInstanceDiagram {
  public static currentPanel: AlloyInstanceDiagram | undefined;
  private readonly _panel: vscode.WebviewPanel;
  private _disposables: vscode.Disposable[] = [];
  private static viewColumn = () => {
    return vscode.ViewColumn.Two;
  };

  private constructor(panel: vscode.WebviewPanel, extensionUri: vscode.Uri) {
    this._panel = panel;

    this._panel.webview.html = this._getWebviewContent(
      this._panel.webview,
      extensionUri
    );
    this._panel.onDidDispose(() => this.dispose(), null, this._disposables);

    // Set an event listener to listen for messages passed from the webview context
    this._setWebviewMessageListener(this._panel.webview);
  }

  public static postMessage(message: ReactEventMessage) {
    console.log("Posting message: ", message);
    if (!AlloyInstanceDiagram.currentPanel) {
      console.warn("No current panel to post message to");
      return;
    }
    AlloyInstanceDiagram.currentPanel?._panel.webview
      .postMessage(message)
      .then((posted) => {
        console.log("Message posted: ", posted);
      });
  }

  public static render(extensionUri: vscode.Uri) {
    if (AlloyInstanceDiagram.currentPanel) {
      // If the webview panel already exists reveal it
      AlloyInstanceDiagram.currentPanel._panel.reveal(this.viewColumn());
    } else {
      // If a webview panel does not already exist create and show a new one
      const panel = vscode.window.createWebviewPanel(
        // Panel view type
        "showAlloyInstance",
        // Panel title
        "Alloy Scenario Explorer",
        // The editor column the panel should be displayed in
        this.viewColumn(),
        // Extra panel configurations
        {
          // Enable JavaScript in the webview
          enableScripts: true,
          // Restrict the webview to only load resources from the `out` and `webview-ui/build` directories
          localResourceRoots: [
            vscode.Uri.joinPath(extensionUri, "client/out"),
            vscode.Uri.joinPath(extensionUri, "client/webview-ui/build"),
            vscode.Uri.joinPath(extensionUri, "client/webview-ui/build/assets"),
          ],
        }
      );

      AlloyInstanceDiagram.currentPanel = new AlloyInstanceDiagram(
        panel,
        extensionUri
      );
    }
  }

  private _getWebviewContent(
    webview: vscode.Webview,
    extensionUri: vscode.Uri
  ) {
    // The CSS file from the React build output
    const stylesUri = getUri(webview, extensionUri, [
      "client",
      "webview-ui",
      "build",
      "assets",
      "index.css",
    ]);
    // const codiconUri = getUri(webview, extensionUri, [
    //   "client",
    //   "webview-ui",
    //   "node_modules",
    //   "@vscode",
    //   "codicons",
    //   "dist",
    //   "codicon.css",
    // ]);
    console.log("stylesUri: ", stylesUri);
    // The JS file from the React build output
    const scriptUri = getUri(webview, extensionUri, [
      "client",
      "webview-ui",
      "build",
      "assets",
      "index.js",
    ]);
    console.log("scriptUri: ", scriptUri);

    const nonce = getNonce();

    // Tip: Install the es6-string-html VS Code extension to enable code highlighting below
    return /*html*/ `
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">
          <meta name="theme-color" content="#000000">
          <meta http-equiv="Content-Security-Policy" content="default-src 'none'; font-src ${webview.cspSource}; style-src ${webview.cspSource}; script-src 'nonce-${nonce}'; img-src ${webview.cspSource} data:;">
          <link nonce="${nonce}" rel="stylesheet" type="text/css" href="${stylesUri}" id="vscode-stylesheet" />
          <link nonce="${nonce}" rel="stylesheet" type="text/css" href="${stylesUri}" id="vscode-codicon-stylesheet" />
          <title>Alloy Scenario Explorer</title>
        </head>
        <body>
          <noscript>You need to enable JavaScript to run this app.</noscript>
          <div id="root"></div>
          <script nonce="${nonce}" src="${scriptUri}"></script>
        </body>
      </html>
    `;
  }

  private _setWebviewMessageListener(webview: vscode.Webview) {
    webview.onDidReceiveMessage(
      (message: ExtensionEventMessage) => {
        console.log("Received message: ", message);
        const eventType = message.eventType;

        switch (eventType) {
          case "ext:getInstance":
            const getInstanceMessage =
              message as extensionEvents.GetInstanceMessage;
            const { alloyCommand: cmd } = getInstanceMessage.body;
            vscode.commands.executeCommand("alloy.runCommand", cmd);
            return;

          case "ext:nextInstance":
            const nextInstanceMessage =
              message as extensionEvents.GetInstanceMessage;
            vscode.commands.executeCommand("alloy.nextInstance");
            return;

          case "ext:showLegacyView":
            const showLegacyViewMessage =
              message as extensionEvents.ShowLegacyViewMessage;
            const legacyViewData = showLegacyViewMessage.body;
            console.log("Received legacy view data: ", legacyViewData);
            vscode.commands.executeCommand(
              "alloy.showLegacyView",
              legacyViewData.alloyCommand
            );
            return;
        }
      },
      undefined,
      this._disposables
    );
  }

  public dispose() {
    AlloyInstanceDiagram.currentPanel = undefined;

    this._panel.dispose();

    while (this._disposables.length) {
      const disposable = this._disposables.pop();
      if (disposable) {
        disposable.dispose();
      }
    }
  }
}
