import * as fs from "fs";
import * as path from "path";

export interface ModelStatsRecord {
  modelName: string;
  filename: string;
  numSignatures: number;
  numRelations: number;
  numFunctions: number;
  numFacts: number;
  numPredicates: number;
  numAssertions: number;
  numCommands: number;
  numOfFormulas: number;
}

const rootOfProject = path.resolve(__dirname, "../../../../../");
const OUTPUT_FILE = path.join(rootOfProject, "test-results", "model-stats.csv");

export class ModelStatsExportUtils {
  public writeCsv(records: ModelStatsRecord[]) {
    const outputDir = path.dirname(OUTPUT_FILE);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const header = [
      "modelName",
      "filename",
      "numSignatures",
      "numRelations",
      "numFunctions",
      "numFacts",
      "numPredicates",
      "numAssertions",
      "numCommands",
      "numOfFormulas",
    ].join(",");

    const rows = records.map((record) =>
      [
        JSON.stringify(record.modelName),
        JSON.stringify(record.filename),
        record.numSignatures,
        record.numRelations,
        record.numFunctions,
        record.numFacts,
        record.numPredicates,
        record.numAssertions,
        record.numCommands,
        record.numOfFormulas,
      ].join(",")
    );

    const csvContent = [header, ...rows].join("\n");
    fs.writeFileSync(OUTPUT_FILE, csvContent);
  }
}
