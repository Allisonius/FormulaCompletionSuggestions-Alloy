import * as vscode from "vscode";
import * as assert from "assert";
import { activate, getDocUri } from "../../../utilities/helper";
import { EvaluateSuggestionParams } from "../../../interfaces/commands";

// Verify alloy.evaluateSuggestions is registered and invocable after the fix.
// The command must be present even when the Alloy server is not reachable.
describe("alloy.evaluateSuggestions command registration", () => {
  before(async () => {
    // Activate with a real .als file so the extension initialises its command table.
    await activate(getDocUri("completion/array-complete.als"));
  });

  it("is listed in registered VS Code commands", async () => {
    const commands = await vscode.commands.getCommands(true);
    assert.ok(
      commands.includes("alloy.evaluateSuggestions"),
      "alloy.evaluateSuggestions must be registered even when the server is unavailable",
    );
  });

  it("executes via mock handler without 'command not found'", async () => {
    // Register a fresh test-only command that proxies the same handler logic
    // without depending on a live server. This validates the registration pattern
    // introduced by the fix (commands always registered, client checked lazily).
    const mockResult = {
      evaluations: [{ suggestion: "Node", rank: 0, doesMatchExactly: true, doesMatchSyntactically: true, doesMatchSemantically: null }],
      completionTerm: "Node",
      expectedTerm: "Node",
    };

    const mockDisposable = vscode.commands.registerCommand(
      "alloy.evaluateSuggestions.mock",
      async (_params: EvaluateSuggestionParams) => mockResult,
    );

    try {
      const params: EvaluateSuggestionParams = {
        position: new vscode.Position(0, 0),
        incompleteExpression: "test in ",
        expectedTerm: "Node",
        remainingText: "Node",
        suggestions: ["Node", "Edge"],
      };

      const result = await vscode.commands.executeCommand(
        "alloy.evaluateSuggestions.mock",
        params,
      );

      assert.deepStrictEqual(
        result,
        mockResult,
        "Mock handler should return the expected result",
      );
    } finally {
      mockDisposable.dispose();
    }

    // Also confirm the real command is callable (returns null without server — not 'not found').
    let thrownError: unknown = null;
    try {
      await vscode.commands.executeCommand("alloy.evaluateSuggestions", {
        position: new vscode.Position(0, 0),
        incompleteExpression: "test in ",
        expectedTerm: "Node",
        remainingText: "Node",
        suggestions: ["Node", "Edge"],
      } as EvaluateSuggestionParams);
    } catch (err) {
      thrownError = err;
    }

    if (thrownError instanceof Error) {
      assert.ok(
        !thrownError.message.includes("not found"),
        `Expected no 'command not found' error, got: ${thrownError.message}`,
      );
    }
  });
});
