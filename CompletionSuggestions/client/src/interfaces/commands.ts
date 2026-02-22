import * as vscode from "vscode";

export interface CommandParams {}

export interface BaseCommand {
    command: string;
    documentUri: string;
    parameters?: CommandParams; // Optional parameters for the command
}

export interface EvaluateSuggestionParams extends CommandParams {
    position: vscode.Position;
    incompleteExpression: string;
    expectedTerm: string;
    remainingText: string;
    suggestions: string[];
}

export interface EvaluateSuggestion extends BaseCommand {
    command: "alloy/evaluateSuggestion";
    parameters: EvaluateSuggestionParams;
}

export interface SuggestionEvaluation {
    suggestion: string;
    rank: number;
    doesMatchExactly: boolean;
    doesMatchSyntactically: boolean | null;
    doesMatchSemantically: boolean | null;
}

export interface EvaluateSuggestionsResponse {
    evaluations: SuggestionEvaluation[];
    completionTerm: string | null;
    expectedTerm: string | null;
}