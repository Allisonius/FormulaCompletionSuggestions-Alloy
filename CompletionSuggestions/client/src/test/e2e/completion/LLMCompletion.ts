import * as vscode from "vscode";
import { exec } from "child_process";

/**
 * AlloyLLMCompletionProvider generates completion suggestions for incomplete Alloy formulas
 * using the Copilot CLI. It receives declarations, extracts the incomplete formula block
 * from the document, builds a context-aware prompt, and returns a list of valid completion
 * expressions.
 */
export class AlloyLLMCompletionProvider {
  private declarations: string;

  constructor(declarations: string) {
    this.declarations = declarations;
  }

  /**
   * Extracts the block (pred, fun, fact, assert) containing the given position.
   * This includes the block header and all content up to the cursor position,
   * preserving block-level declarations like quantifier variables.
   *
   * @param documentText - The full text of the Alloy document
   * @param position - The cursor position (0-indexed line and character)
   * @returns The incomplete formula block up to the cursor position
   */
  public extractIncompleteFormula(
    documentText: string,
    position: vscode.Position,
  ): string {
    const lines = documentText.split("\n");
    const targetLine = position.line;

    // Find the start of the block containing the position
    let blockStartLine = -1;
    let braceDepth = 0;

    // Scan backwards to find block start
    for (let i = targetLine; i >= 0; i--) {
      const line = lines[i];

      // Count braces in reverse to track depth
      for (let j = line.length - 1; j >= 0; j--) {
        // If we're on the target line, only count up to the cursor position
        if (i === targetLine && j >= position.character) {
          continue;
        }

        const char = line[j];
        if (char === "}") {
          braceDepth++;
        } else if (char === "{") {
          braceDepth--;
          if (braceDepth < 0) {
            // Found the opening brace of our block
            // Now find the block header (pred, fun, fact, assert)
            blockStartLine = i;

            // Check if the block keyword is on a previous line
            const trimmedLine = line.trim();
            if (!trimmedLine.match(/^(pred|fun|fact|assert)\s+/)) {
              // Look for the block keyword on previous lines
              for (let k = i - 1; k >= 0; k--) {
                const prevLine = lines[k].trim();
                if (prevLine.match(/^(pred|fun|fact|assert)\s+/)) {
                  blockStartLine = k;
                  break;
                }
                // Stop if we hit another block or declaration
                if (
                  prevLine.match(
                    /^(sig|open|pred|fun|fact|assert|run|check)\s+/,
                  )
                ) {
                  break;
                }
              }
            }
            break;
          }
        }
      }

      if (blockStartLine !== -1) {
        break;
      }
    }

    // If no block found, just return the current line up to cursor
    if (blockStartLine === -1) {
      return lines[targetLine].substring(0, position.character);
    }

    // Extract from block start to cursor position
    const blockLines: string[] = [];
    for (let i = blockStartLine; i <= targetLine; i++) {
      if (i === targetLine) {
        // Only include up to the cursor position on the target line
        blockLines.push(lines[i].substring(0, position.character));
      } else {
        blockLines.push(lines[i]);
      }
    }

    return blockLines.join("\n");
  }

  /**
   * Builds a prompt for the LLM to generate Alloy formula completions.
   *
   * @param incompleteFormula - The incomplete formula that needs completion
   * @returns The constructed prompt string
   */
  public buildPrompt(incompleteFormula: string): string {
    return `You are an expert in Alloy, a declarative specification language for expressing structural constraints and behavior.

Given the following Alloy model declaration:
\`\`\`alloy
${this.declarations}
\`\`\`

And the following incomplete Alloy formula:
\`\`\`alloy
${incompleteFormula}
\`\`\`

Generate a list of valid completions for this formula. Consider:
1. Variables in scope from quantifiers (e.g., "all p: Person" makes "p" available)
2. Fields/relations accessible from the current expression context
3. Alloy operators: "." (join), "~" (transpose), "^" (transitive closure), "*" (reflexive-transitive closure)
4. Type compatibility based on the declared signatures and relations
5. The special constant "univ" (universal set)

Generate completions that would result in syntactically correct and type-valid Alloy expressions. Generate only expressions that can directly follow the incomplete part.

Avoid:
1. Entire formula, like "all p: Person | ...".
2. Sub-formulas, like "a = b" or "some r".

ACCEPTABLE COMPLETION EXAMPLES:
- If "p" is a variable of type "Person" and "friends" is a field of type "Person -> Person", valid completions include:
  - "p.friends"
  - "p.friends.~friends"
  - "p.friends + univ"
  - "p.friends & univ"

- If "r" is a relation of type "A -> B" and "s" is a relation of type "B -> C", valid completions include:
  - "r.s"
  - "r.s^"
  - "r.s*"
  - "~r"

UNACCEPTABLE COMPLETION EXAMPLES:
- "all p: Person | p.friends" (entire formula)
- "some r" (sub-formula)
- "a + b" (sub-formula)
- "p.friends.age" (if "age" is not a valid field of "Person")

Return ONLY a JSON array of completion strings, ordered by relevance. Each completion should be a valid expression that can follow the incomplete part.

Example format: ["field1", "field1.subfield", "field2.~otherField", "variable"]

Do not include any explanation, just the JSON array.`;
  }

  /**
   * Parses the LLM response text and converts it to CompletionItem array.
   *
   * @param responseText - The raw response text from the LLM
   * @returns An array of vscode.CompletionItem objects
   */
  public parseResponse(responseText: string): vscode.CompletionItem[] {
    try {
      // Try to extract JSON array from the response
      const jsonMatch = responseText.match(/\[[\s\S]*\]/);
      if (!jsonMatch) {
        console.warn("LLMCompletion: No JSON array found in response");
        return [];
      }

      const completions: string[] = JSON.parse(jsonMatch[0]);

      if (!Array.isArray(completions)) {
        console.warn("LLMCompletion: Parsed result is not an array");
        return [];
      }

      return completions.map((completion, index) => {
        const item = new vscode.CompletionItem(
          completion,
          vscode.CompletionItemKind.Text,
        );
        item.sortText = index.toString().padStart(5, "0");
        return item;
      });
    } catch (error) {
      console.warn("LLMCompletion: Failed to parse response:", error);
      return [];
    }
  }

  /**
   * Main entry point for generating completions using the LLM.
   *
   * @param documentText - The full text of the Alloy document
   * @param position - The cursor position where completion is requested
   * @param token - Cancellation token for the operation
   * @returns A promise that resolves to an array of CompletionItem objects
   */
  public async getCompletions(
    documentText: string,
    position: vscode.Position,
    token: vscode.CancellationToken,
  ): Promise<vscode.CompletionItem[]> {
    try {
      // Extract the incomplete formula block from the document
      const incompleteFormula = this.extractIncompleteFormula(
        documentText,
        position,
      );
      const prompt = this.buildPrompt(incompleteFormula);

      const responseText = await this.requestCompletionWithCopilotCli(
        prompt,
        token,
      );

      if (!responseText) {
        return [];
      }

      return this.parseResponse(responseText);
    } catch (error) {
      if (error instanceof vscode.CancellationError) {
        // Request was cancelled, return empty
        return [];
      }
      console.warn("LLMCompletion: Error generating completions:", error);
      return [];
    }
  }

  private requestCompletionWithCopilotCli(
    prompt: string,
    token: vscode.CancellationToken,
  ): Promise<string> {
    return new Promise((resolve) => {
      const promptArg = this.toCopilotCliPromptArg(prompt);
      const model = "gpt-4.1"; // You can make this configurable if needed
      const command = `copilot --model ${model} -s -p ${promptArg}`;

      const child = exec(
        command,
        { maxBuffer: 10 * 1024 * 1024 },
        (error, stdout, stderr) => {
          if (token.isCancellationRequested) {
            return resolve("");
          }

          if (error) {
            console.warn("LLMCompletion: Copilot CLI failed:", error, stderr);
            return resolve("");
          }

          if (stderr && stderr.trim().length > 0) {
            console.warn("LLMCompletion: Copilot CLI stderr:", stderr);
          }

          resolve(stdout);
        },
      );

      token.onCancellationRequested(() => {
        child.kill();
      });
    });
  }

  private toCopilotCliPromptArg(prompt: string): string {
    const escaped = prompt
      .replace(/\\/g, "\\\\")
      .replace(/'/g, "\\'")
      .replace(/\r?\n/g, "\\n");
    return `$'${escaped}'`;
  }
}
