# Formula Completion Suggestions for Alloy README

This repo contains source code, experimental inputs, and experimental results for the "Formula Completion Suggestions for Alloy Models with Selection Guidance" paper. Each folder contains a README with additional information and instructions.

The folders contain the following

- **CompletionSuggestions:** Includes the code, data and instructions to install the Alloy Language Server, which is a Visual Studio Code extension that performs our formula completion suggestions. Within this folder, there are instructions on how to generate the suggestions using (1) our completion suggestions, (2) the AGen "generator" baseline and (3) LLM models are provided by the github copilot. The latter of which was only used for a small investigation over a subset of the models and not presented in the paper.
- **TemplateRankings:** Includes the code, data and instructions to take the suggestions produced by the framework in `CompletionSuggestions` and rank them based on historical template frequency.
- **CorpusTemplates:** Includes the code, data and instructions to produce the templates over our corpus of models. Our filtered corpus of models is also in this folder.
- **ContrastingScenario:** Includes the code, data and instructions to take the suggestions produced by the framework in `CompletionSuggestions` and create a contrasting scenario for each unique completion location.
- **ImpactAnalysis:** Includes the code, data and instructions to take the suggestions produced by the framework in `CompletionSuggestions` and create an impact analysis for each suggestion for each completion location.
- **RuntimeAnalysis:** A correlation between large model properties and runtime of different stages of our completion suggestions can be found in `RuntimeCorrelations.xlsx`. Code to calculate runtimes for each stage is included in the respective folder of the stage, and not in this folder. Only results and analysis are in this folder.
