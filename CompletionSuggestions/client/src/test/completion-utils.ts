import * as vscode from "vscode";
import { EvaluateSuggestionParams, EvaluateSuggestionsResponse } from "../interfaces/commands";
import { AlloyLLMCompletionProvider } from "./e2e/completion/LLMCompletion";

export const COMPLETION_TERMS = [
  " in ",
  " extends ",
  " & ",
  " + ",
  " - ",
  ".",
  " -> ",
];

export interface CompletionOffset {
  offset: number;
  term: string;
}

export async function testCompletion(
  docUri: vscode.Uri,
  position: vscode.Position,
  alloyModelDeclaration: string | null = null
): Promise<vscode.CompletionList> {
  if (process.env["LLM_COMPLETION"] === "true") {
    const documentText = (await vscode.workspace.openTextDocument(docUri)).getText();
    const provider = new AlloyLLMCompletionProvider(alloyModelDeclaration ?? "");
    const completions = await provider.getCompletions(documentText, position, new vscode.CancellationTokenSource().token);
    return new vscode.CompletionList(completions, false);
  }
  // Executing the command `vscode.executeCompletionItemProvider` to simulate triggering completion
  const actualCompletionList = (await vscode.commands.executeCommand(
    "vscode.executeCompletionItemProvider",
    docUri,
    position
  )) as vscode.CompletionList;
  return actualCompletionList;
}

export interface SuggestionImpact {
  baselineExpression: string;
  suggestedExpression: string;
  A_iff_B: boolean;
  A_and_B: boolean;
  not_A_and_B: boolean;
  A_and_not_B: boolean;
  not_A_and_not_B: boolean;
}

export async function testSuggestionImpact(
  docUri: vscode.Uri,
  incompletionFormula: string,
  suggestion: string,
  position: vscode.Position
): Promise<SuggestionImpact | null> {
  // Executing the command `alloy.suggestionImpact` to simulate triggering suggestion impact
  try {
    const result = await vscode.commands.executeCommand(
      "alloy.suggestionImpact",
      suggestion,
      incompletionFormula,
      position
    );
    return result as SuggestionImpact;
  } catch (error) {
    console.error("Error executing alloy.suggestionImpact:", error);
    return null;
  }
}

export async function evaluateSuggestions(
  evaluateSuggestionParams: EvaluateSuggestionParams,
): Promise<EvaluateSuggestionsResponse | null> {
  try {
    const evaluationResult = await vscode.commands.executeCommand("alloy.evaluateSuggestions", {
      ...evaluateSuggestionParams
    });
    return evaluationResult as EvaluateSuggestionsResponse;
  } catch (error) {
    console.error("Error executing alloy.evaluateSuggestions:", error);
  }
}

export function getExpectedCompletionTerm(
  text: String,
  offset: number,
  breakJoinedTerms
): string {
  let completionTerm = "";
  for (let i = offset; i < text.length; i++) {
    if (text.substring(i, i + 4) === " -> ") {
      completionTerm += text.substring(i, i + 4);
      i += 3;
      continue;
    }
    if (
      text[i] === " " ||
      text[i] === "\n" ||
      text[i] === "\t" ||
      (text[i] === "." && breakJoinedTerms) ||
      text[i] === "(" ||
      text[i] === ")" ||
      text[i] === "{" ||
      text[i] === "}" ||
      text[i] === "[" ||
      text[i] === "]" ||
      text[i] === ","
    ) {
      break;
    }
    completionTerm += text[i];
  }
  return completionTerm;
}

export function getCompletionOffsets(
  text: String,
  completionTerms: string[],
  initialOffset = 0
): CompletionOffset[] {
  const offsets: CompletionOffset[] = [];
  for (let i = initialOffset; i < text.length; i++) {
    if (text.substring(i, i + 2) === "//") {
      while (text[i] !== "\n") i++;
      continue;
    }
    if (text.substring(i, i + 2) === "/*") {
      while (text.substring(i, i + 2) !== "*/") i++;
      i += 2;
      continue;
    }
    for (const term of completionTerms) {
      const termLength = term.length;
      if (text.substring(i, i + termLength) === term) {
        offsets.push({ offset: i + termLength, term: term });
        i += termLength;
      }
    }
  }
  return offsets;
}
