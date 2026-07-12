import * as vscode from "vscode";
import { exec } from "child_process";

/**
 * AlloyLLMCompletionProvider generates completion suggestions for incomplete Alloy formulas
 * using the VS Code Language Model API (GitHub Copilot). It receives declarations, extracts
 * the incomplete formula block from the document, builds a context-aware prompt, and returns
 * a list of valid completion expressions.
 */
export class AlloyLLMCompletionProvider {
  private declarations: string;
  private cache = new Map<string, vscode.CompletionItem[]>();

  constructor(declarations: string) {
    this.declarations = declarations;
  }

  /**
   * Extracts the block (pred, fun, fact, assert) containing the given position.
   * This includes the block header and all content up to the cursor position,
   * preserving block-lel declarations like quantifier variables.
   */
  public extractIncompleteFormula(
    documentText: string,
    position: vscode.Position,
  ): string {
    const lines = documentText.split("\n");
    const targetLine = position.line;

    let blockStartLine = -1;
    let braceDepth = 0;

    for (let i = targetLine; i >= 0; i--) {
      const line = lines[i];

      for (let j = line.length - 1; j >= 0; j--) {
        if (i === targetLine && j >= position.character) {
          continue;
        }

        const char = line[j];
        if (char === "}") {
          braceDepth++;
        } else if (char === "{") {
          braceDepth--;
          if (braceDepth < 0) {
            blockStartLine = i;

            const trimmedLine = line.trim();
            if (!trimmedLine.match(/^(pred|fun|fact|assert)\s+/)) {
              for (let k = i - 1; k >= 0; k--) {
                const prevLine = lines[k].trim();
                if (prevLine.match(/^(pred|fun|fact|assert)\s+/)) {
                  blockStartLine = k;
                  break;
                }
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

    if (blockStartLine === -1) {
      return lines[targetLine].substring(0, position.character);
    }

    const blockLines: string[] = [];
    for (let i = blockStartLine; i <= targetLine; i++) {
      if (i === targetLine) {
        blockLines.push(lines[i].substring(0, position.character));
      } else {
        blockLines.push(lines[i]);
      }
    }

    return blockLines.join("\n");
  }

  private detectOperator(formula: string): string {
    const trimmed = formula.trimEnd();
    if (trimmed.endsWith("->")) return "->";
    if (trimmed.endsWith(".")) return ".";
    if (/\bin\s*$/.test(trimmed)) return "in";
    if (/\bextends\s*$/.test(trimmed)) return "extends";
    if (trimmed.endsWith("&")) return "&";
    if (trimmed.endsWith("+")) return "+";
    if (trimmed.endsWith("-")) return "-";
    return "general";
  }

  private operatorGuidance(operator: string): string {
    switch (operator) {
      case ".":
        return '"." (join) — suggest a field name or relation reachable from the left expression';
      case "->":
        return '"->" (product) — suggest a type or set for the right side of the product';
      case "in":
        return '"in" (membership) — suggest a signature or set the left expression can belong to';
      case "extends":
        return '"extends" — suggest a signature name to extend';
      case "&":
        return '"&" (intersection) — suggest a set of the same type as the left side';
      case "+":
        return '"+" (union) — suggest a set of the same type as the left side';
      case "-":
        return '"-" (difference) — suggest a set of the same type as the left side';
      default:
        return "general — suggest any valid Alloy expression or atom in scope";
    }
  }

  /**
   * Parses raw Alloy declarations into a compact structured summary so the LLM
   * does not need to parse Alloy syntax itself.
   */
  private parseDeclarations(declarations: string): string {
    const lines: string[] = [];
    const normalized = declarations.replace(/\r?\n/g, " ").replace(/\s+/g, " ");

    const sigPattern = /sig\s+(\w+)(?:\s+(in|extends)\s+(\w+))?\s*\{([^}]*)\}/g;
    let match: RegExpExecArray | null;
    while ((match = sigPattern.exec(normalized)) !== null) {
      const name = match[1];
      const rel = match[2];
      const parent = match[3];
      const body = match[4].trim();

      let line = `• ${name}`;
      if (parent) {
        line += rel === "in" ? ` ⊆ ${parent}` : ` extends ${parent}`;
      }
      if (body) {
        const fields = body
          .split(",")
          .map((f) => f.trim())
          .filter(Boolean)
          .join(", ");
        line += ` { ${fields} }`;
      }
      lines.push(line);
    }

    return lines.length > 0 ? lines.join("\n") : declarations.trim();
  }

  /**
   * Extracts quantifier variable bindings in scope from the formula text.
   * e.g. "all p: Person | some c: Course |" → ["p: Person", "c: Course"]
   */
  private extractQuantifierVars(formula: string): string[] {
    const pattern =
      /\b(?:all|some|lone|one|no)\s+([\w,\s]+)\s*:\s*([\w\[\]]+)/g;
    const vars: string[] = [];
    let m: RegExpExecArray | null;
    while ((m = pattern.exec(formula)) !== null) {
      const names = m[1]
        .split(",")
        .map((n) => n.trim())
        .filter(Boolean);
      const type = m[2];
      names.forEach((n) => vars.push(`${n}: ${type}`));
    }
    return vars;
  }

  /**
   * Builds a concise, operator-aware prompt for the LLM.
   */
  public buildPrompt(incompleteFormula: string): string {
    const operator = this.detectOperator(incompleteFormula);
    const structuredDecls = this.parseDeclarations(this.declarations);
    const quantVars = this.extractQuantifierVars(incompleteFormula);
    const scopeSection =
      quantVars.length > 0
        ? quantVars.join(", ")
        : "none (use signature names directly)";

    return `You are an Alloy expression completion engine. Return ONLY a JSON array of 5–10 completions.

Model signatures and fields:
${structuredDecls}

Quantifier variables in scope: ${scopeSection}

Incomplete formula:
\`\`\`alloy
${incompleteFormula}
\`\`\`

Operator context: ${this.operatorGuidance(operator)}

Alloy operators: "." (join), "~" (transpose), "^" (transitive closure), "*" (reflexive-transitive closure), "+" (union), "&" (intersection), "->" (product).
Special constants: none, univ, iden.

Return format — JSON array only, no explanation:
["completion1", "completion2", ...]`;
  }

  /**
   * Parses the LLM response text and converts it to CompletionItem array.
   */
  public parseResponse(responseText: string): vscode.CompletionItem[] {
    try {
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
   */
  public async getCompletions(
    documentText: string,
    position: vscode.Position,
    token: vscode.CancellationToken,
  ): Promise<vscode.CompletionItem[]> {
    try {
      const incompleteFormula = this.extractIncompleteFormula(
        documentText,
        position,
      );

      const cacheKey = `${this.declarations}|||${incompleteFormula}`;
      const cached = this.cache.get(cacheKey);
      if (cached) {
        console.log("LLMCompletion: Cache hit");
        return cached;
      }

      const prompt = this.buildPrompt(incompleteFormula);
      const responseText = await this.requestCompletionWithVSCodeLM(
        prompt,
        token,
      );

      if (!responseText) {
        return [];
      }

      const items = this.parseResponse(responseText);
      this.cache.set(cacheKey, items);
      return items;
    } catch (error) {
      if (error instanceof vscode.CancellationError) {
        return [];
      }
      console.warn("LLMCompletion: Error generating completions:", error);
      return [];
    }
  }

  private async requestCompletionWithVSCodeLM(
    prompt: string,
    token: vscode.CancellationToken,
  ): Promise<string> {
    const models = await vscode.lm.selectChatModels({
      vendor: "copilot",
      family: "gpt-4.1-mini",
    });

    if (!models.length) {
      // Fall back to Copilot CLI when the LM API is unavailable (e.g. not signed in)
      console.warn(
        "LLMCompletion: No Copilot LM model available, falling back to CLI",
      );
      return this.requestCompletionWithCopilotCli(prompt, token);
    }

    const response = await models[0].sendRequest(
      [vscode.LanguageModelChatMessage.User(prompt)],
      {},
      token,
    );

    let text = "";
    for await (const chunk of response.text) {
      text += chunk;
    }
    return text;
  }

  private requestCompletionWithCopilotCli(
    prompt: string,
    token: vscode.CancellationToken,
  ): Promise<string> {
    return new Promise((resolve) => {
      const escaped = prompt
        .replace(/\\/g, "\\\\")
        .replace(/'/g, "\\'")
        .replace(/\r?\n/g, "\\n");
      const command = `copilot --model gpt-4.1 -s -p $'${escaped}'`;

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
          resolve(stdout);
        },
      );

      token.onCancellationRequested(() => child.kill());
    });
  }
}
