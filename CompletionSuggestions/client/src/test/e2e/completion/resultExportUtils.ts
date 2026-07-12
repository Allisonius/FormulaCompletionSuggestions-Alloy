import * as vscode from "vscode";
import * as fs from "fs";
import * as path from "path";
import { TEST_VARIANT, EXPORT_MODE } from "./AlloyFileSetup";
import { CompletionOffset, SuggestionImpact } from "../../completion-utils";
import { EvaluateSuggestionsResponse } from "../../../interfaces/commands";
import { time } from "console";

// const RESULT_MODE: EXPORT_MODE[] = [EXPORT_MODE.file];
const CLEAR_RESULTS = true;
// const IGNORE_TRUE_CASES = false;

const rootOfProject = path.resolve(__dirname, "../../../../../");
var OUTPUT_TEST_DIR = path.join(rootOfProject, "test-results/formula");
if (process.env["GENERATOR_COMPLETION"] === "true") {
  OUTPUT_TEST_DIR = path.join(rootOfProject, "test-results/generator");
}
if (process.env["LLM_COMPLETION"] === "true") {
  if (process.env["LLM_MODEL"]) {
    OUTPUT_TEST_DIR = path.join(
      rootOfProject,
      `test-results/llm-${process.env["LLM_MODEL"]}`,
    );
  } else {
    // use the model selected by copilot cli
    OUTPUT_TEST_DIR = path.join(rootOfProject, "test-results/llm");
  }
}

export class CompletionResultExportUtils {
  private exportModes: EXPORT_MODE[] = [EXPORT_MODE.file];
  private ignoreTrueCases: boolean = false;

  constructor(
    exportModes: EXPORT_MODE[] = [EXPORT_MODE.file],
    ignoreTrueCases: boolean = false,
  ) {
    this.exportModes = exportModes;
    this.ignoreTrueCases = ignoreTrueCases;
  }

  private _appendResultToCsv = (modelDir: string, modelName: string, result: any) => {
    const csvPath = `${modelDir}/${modelName}-results.csv`;
    const columns = [
      "modelName", "filename", "offset", "term", "line", "character",
      "incompletionLine", "completionList", "completionGenerated", "suggestionExists",
      "expectedCompletionWord", "expectedCompletionLine", "elapsedTimeInMs",
      "preprocessingTime", "parsingTime", "generationTime",
      "evaluationResult_count", "evaluationResult_exact_matches",
      "evaluationResult_syntactic_matches", "evaluationResult_semantic_matches",
      "evaluationResult_semantic_match_count",
    ];

    const evalArr: any[] = Array.isArray(result.evaluationResult) ? result.evaluationResult : [];
    const derived: Record<string, any> = {
      evaluationResult_count: evalArr.length,
      evaluationResult_exact_matches: evalArr.some((e) => e.doesMatchExactly),
      evaluationResult_syntactic_matches: evalArr.some((e) => e.doesMatchSyntactically),
      evaluationResult_semantic_matches: evalArr.some((e) => e.doesMatchSemantically),
      evaluationResult_semantic_match_count: evalArr.filter((e) => e.doesMatchSemantically).length,
    };

    const formatValue = (v: any) =>
      v === undefined || v === null ? "" : typeof v === "string" ? JSON.stringify(v) : String(v);
    const row = columns.map((col) => formatValue(col in derived ? derived[col] : result[col])).join(",") + "\n";
    if (!fs.existsSync(csvPath)) {
      fs.writeFileSync(csvPath, columns.join(",") + "\n" + row);
    } else {
      fs.appendFileSync(csvPath, row);
    }
  };

  private _exportResultToFile = (
    modelName: String,
    position: vscode.Position,
    summary: string,
    incompleteText: string,
    result: any,
    variant: TEST_VARIANT,
  ) => {
    // const modelDir = `${TEST_DIR}/${modelName}`;
    const suffix = `l${position.line + 1}-c${position.character}`;
    const modelDir = `${OUTPUT_TEST_DIR}/${TEST_VARIANT[variant]}/${modelName}`;
    if (!fs.existsSync(modelDir)) {
      fs.mkdirSync(modelDir, { recursive: true });
    }
    if (!result.suggestionExists || !this.ignoreTrueCases) {
      fs.writeFileSync(
        `${modelDir}/${modelName}-${suffix}-${result.suggestionExists}.smry`,
        summary,
      );
      fs.writeFileSync(
        `${modelDir}/${modelName}-${suffix}.als`,
        incompleteText,
      );
    }

    fs.writeFileSync(
      `${modelDir}/${modelName}-${suffix}.result.json`,
      JSON.stringify(result),
    );

    this._appendResultToCsv(modelDir, String(modelName), result);
  };

  private _exportResultToConsole = (summary: String, result: any) => {
    console.log(summary);
    console.log(result);
  };

  public expResult = async (
    modelName: string,
    filename: string,
    offset: CompletionOffset,
    position: vscode.Position,
    incompleteText: string,
    incompleteLine: string,
    removedText: string,
    completionList: vscode.CompletionList,
    evaluationResult: EvaluateSuggestionsResponse | null,
    expectedCompletion: string,
    elapsedTimeInMs: number,
    variant: TEST_VARIANT,
    timeMeasuringItem: vscode.CompletionItem | null,
  ) => {
    filename = filename.split("/testFixture/").pop();
    // const findSuggestions = (completionList: vscode.CompletionItem[]) => {
    //   return completionList.some(
    //     (item) =>
    //       item.label.toString().trim() ===
    //         evaluationResult.expectedTerm.trim() ||
    //       (variant === TEST_VARIANT.multi_term &&
    //         removedText.trim().startsWith(item.label.toString().trim())),
    //   );
    // };

    const findSuggestions2 = (
      evaluationResult: EvaluateSuggestionsResponse,
    ) => {
      return evaluationResult.evaluations.some(
        (item) => item.doesMatchExactly || item.doesMatchSyntactically,
      );
    };

    // Structural(default) sorting
    // const suggestionExists = findSuggestions(completionList.items);
    const suggestionExists = findSuggestions2(evaluationResult);
    // const suggestionInTop1 = findSuggestions(completionList.items.slice(0, 1));
    // const suggestionInTop5 = findSuggestions(completionList.items.slice(0, 5));
    // const suggestionInTop10 = findSuggestions(
    //   completionList.items.slice(0, 10),
    // );

    // Alphabetical sorting
    var alphaSorted = [...completionList.items].sort((a, b) =>
      a.label.toString().localeCompare(b.label.toString()),
    );
    // const suggestionInTop1Alpha = findSuggestions(alphaSorted.slice(0, 1));
    // const suggestionInTop5Alpha = findSuggestions(alphaSorted.slice(0, 5));
    // const suggestionInTop10Alpha = findSuggestions(alphaSorted.slice(0, 10));

    // Sorted by length
    var lengthSorted = [...completionList.items].sort(
      (a, b) => a.label.toString().length - b.label.toString().length,
    );
    // const suggestionInTop1Len = findSuggestions(lengthSorted.slice(0, 1));
    // const suggestionInTop5Len = findSuggestions(lengthSorted.slice(0, 5));
    // const suggestionInTop10Len = findSuggestions(lengthSorted.slice(0, 10));

    const evaluationSummary = evaluationResult
      ? evaluationResult.evaluations
          .map(
            (item) =>
              `$${item.rank}. ${item.suggestion} \t ${item.doesMatchExactly} \t ${item.doesMatchSyntactically} \t ${item.doesMatchSyntactically}`,
          )
          .join("\n")
      : "No Suggestions";

    //prettier-ignore
    const summary = 
`Model name: ${modelName}
Filename: ${filename}
Offset: ${offset.offset}
Term: ${offset.term}
Vscode Position: line=${position.line} character=${position.character}
----------------------------------
${position.line + 1} | ${incompleteLine}
----------------------------------
Expected Completion word: ${evaluationResult.expectedTerm}
Expected Completion line: ${removedText}
Suggestion exists: ${suggestionExists}
Completion List:
# Suggestion \t Exact \t Syntactic \t Semantic
${evaluationSummary}

Time taken: ${elapsedTimeInMs}
Preprocessing time: ${timeMeasuringItem ? timeMeasuringItem.insertText : "N/A"}
Parsing time: ${timeMeasuringItem ? timeMeasuringItem.detail : "N/A"}
Generation time: ${timeMeasuringItem ? timeMeasuringItem.documentation : "N/A"}`;

    const result = {
      modelName: modelName,
      filename: filename,
      offset: offset.offset,
      term: offset.term,
      line: position.line + 1,
      character: position.character,
      incompletionLine: incompleteLine.trim(),
      completionList: completionList.items.map((item) => item.label).join(", "),
      evaluationResult: evaluationResult.evaluations,
      completionGenerated: completionList.items.length > 0,
      suggestionExists: suggestionExists,
      // suggestionInTop1: suggestionInTop1,
      // suggestionInTop5: suggestionInTop5,
      // suggestionInTop10: suggestionInTop10,
      // suggestionInTop1Alpha: suggestionInTop1Alpha,
      // suggestionInTop5Alpha: suggestionInTop5Alpha,
      // suggestionInTop10Alpha: suggestionInTop10Alpha,
      // suggestionInTop1Len: suggestionInTop1Len,
      // suggestionInTop5Len: suggestionInTop5Len,
      // suggestionInTop10Len: suggestionInTop10Len,
      expectedCompletionWord: evaluationResult.expectedTerm,
      expectedCompletionLine: removedText.trim(),
      elapsedTimeInMs: elapsedTimeInMs,
    };

    if (timeMeasuringItem) {
      result["preprocessingTime"] = timeMeasuringItem.insertText;
      result["parsingTime"] = timeMeasuringItem.detail;
      result["generationTime"] = timeMeasuringItem.documentation;
    }

    for (const mode of this.exportModes) {
      switch (mode) {
        case EXPORT_MODE.file:
          this._exportResultToFile(
            modelName,
            position,
            summary,
            incompleteText,
            result,
            variant,
          );
          break;
        case EXPORT_MODE.console:
          this._exportResultToConsole(summary, result);
          break;
      }
    }
  };
}

export class SuggestionImpactExportUtils {
  private exportModes: EXPORT_MODE[] = [EXPORT_MODE.file];

  constructor(exportModes: EXPORT_MODE[] = [EXPORT_MODE.file]) {
    this.exportModes = exportModes;
  }

  public expResult = async (
    modelName: string,
    filename: string,
    offset: CompletionOffset,
    position: vscode.Position,
    incompleteLine: string,
    removedText: string,
    // suggestion: string,
    suggestionImpactTime: number,
    suggestionImpactList: SuggestionImpact[],
  ) => {
    filename = filename.split("/testFixture/").pop();
    const line = position.line + 1;
    const character = position.character;
    const suffix = `l${line}-c${character}-suggestions-impact.csv`;
    const modelDir = `${OUTPUT_TEST_DIR}/suggestion-impacts/${modelName}`;
    if (!fs.existsSync(modelDir)) {
      fs.mkdirSync(modelDir, { recursive: true });
    }
    const csvHeader = [
      "modelname",
      "filename",
      "position-line",
      "position-character",
      "incompleteline",
      "removedtext",
      "baseline",
      "suggestionedExpression",
      "A_iff_B",
      "A_and_B",
      "not_A_and_B",
      "A_and_not_B",
      "not_A_and_not_B",
      "suggestionImpactTime",
    ].join(",");
    const csvRows = suggestionImpactList.map((impact) =>
      [
        modelName,
        filename,
        line,
        character,
        JSON.stringify(incompleteLine.trim()),
        JSON.stringify(removedText.trim()),
        JSON.stringify(impact.baselineExpression),
        JSON.stringify(impact.suggestedExpression),
        impact.A_iff_B,
        impact.A_and_B,
        impact.not_A_and_B,
        impact.A_and_not_B,
        impact.not_A_and_not_B,
        suggestionImpactTime,
      ].join(","),
    );
    const csvContent = [csvHeader, ...csvRows].join("\n");
    fs.writeFileSync(`${modelDir}/${modelName}-${suffix}`, csvContent);
  };
}
