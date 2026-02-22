# Formula Completion Suggestions for Alloy README

This repo contains source code, experimental inputs, and experimental results for the Formula Completion Suggestions. Each folder contains a README with additional information and instructions.

The folders contain the following

- **CompletionSuggestions:** Includes the code, data and instructions to install the Alloy Language Server, which is a Visual Studio Code extension that performs our formula completion suggestions. Within this folder, there are instructions on how to generate the suggestions using (1) our completion suggestions, (2) the AGen "generator" baseline and (3) chatgpt-5.1. The latter of which is used for a small investigation over a subset of the models.
- **TemplateRankings:** Includes the code, data and instructions to take the suggestions produced by the framework in `CompletionSuggestions` and rank them based on historical template frequency.
- **CorpusTemplates:** Includes the code, data and instructions to produce the templates over our corpus of models.
- **ContrastingScenario:** Includes the code, data and instructions to take the suggestions produced by the framework in `CompletionSuggestions` and create a contrasting scenario for each unique completion location.
- **ImpactAnalysis:** Includes the code, data and instructions to take the suggestions produced by the framework in `CompletionSuggestions` and create an impact analysis for each suggestion for each completion location.
