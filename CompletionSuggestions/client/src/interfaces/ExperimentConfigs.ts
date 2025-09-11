export interface CompletionInputConfig {
    sigOnlyFileUri: string;
    completeFileUri: string;
}

export interface CompletionExportConfig {
    outputDir: string;
    clearPreviousResults: boolean;
    ignoreTrueCases: boolean;
}

export interface CompletionExperimentConfig {
    modelName: string;
}