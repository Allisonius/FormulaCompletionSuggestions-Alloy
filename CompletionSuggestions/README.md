# Alloy-Language-Extension README

Alloy Langauge Extension is a Visual Studio Code extension that adds rich programming features for the modeling language Alloy. This version of the extension is a prototype and is not yet ready for production use. This extension is part of the Alloy Live Programming project, which aims to provide a live programming environment for the Alloy modeling language.

This projects have 2 main components: the extension client and the language server. The extension client is the Visual Studio Code extension that provides the features to the user. The language server is a lsp4j implementation that provides the language features to the extension client following the Language Server Protocol.

This project runs an experiment for formula completion in Alloy. The extension client sends a request to the language server to get the completions for a formula. The language server uses the Alloy Analyzer to get the completions for the formula. The completions are then sent back to the extension client, which displays them to the user.

## Requirements

### Extension client

- node.js v18.18.2 or higher
- npm 9.8.1 or higher

### Language server

- Java 21 or higher
- Gradle

## How to build

Clone the repository and run the following commands inside the root directory of the project:

    npm install
    npm run compile # this is for installing the extension dependencies

### Extension client

    cd client
    npm install
    npm run compile # this is for installing the client dependencies

### Language server

    cd server
    gradle build

# Tests and Experiments

The experiment installs a sandbox vscode instance. Then it runs the experiment from the Alloy model files localed in the [client/testFixture](./client/testFixture) folder.

We have the completion experiments with 3 modes to run:

1. Formula Completion
2. Static Generator completion
3. LLM-based completion

## Run the Formula Completion Experiment

To run the experiment for formula completions, run the following command:

    npm run experiment:completion:formula

This will launch a sandbox vscode instance and run the test suite. The results will be stored in the [test-results/formula](./test-results/formula/) directory.

## Run the Static Generator Completion Experiment

To run the experiment for static generator completions, run the following command:

    npm run experiment:completion:generator

This will launch a sandbox vscode instance and run the test suite. The results will be stored in the [test-results/generator](./test-results/generator/) directory.

## Run the LLM-based Completion Experiment

### Prequisites

The LLM models are provided by the github copilot. The copilot cli tool is used to run the experiment with different models. To install the copilot cli tool, follow the instructions in the [copilot cli repository](https://github.com/github/copilot-cli).

### Running the experiment

To run the experiment for LLM-based completions, run the following command:

    npm run experiment:completion:llm -- --model <model-name>

This will launch a sandbox vscode instance and run the test suite. The results will be stored in the [test-results/llm](./test-results/llm-<model_name>/) directory. If no model name is provided, the experiment will run with the default model, which is `gpt-4.1`.

The list of available models can be found in the help text with `model` param from this command:

    copilot help config

## Experiment Result Analysis

To analyze experiment results, refer to the Jupyter notebooks in the [analysis](./analysis) directory. The following jupyter notebooks are available:

- [Completion Performance Summary](./analysis/completion_performance_summary.ipynb)
- [LLM Completion Performance](./analysis/llm_completion_performance.ipynb)
- [Completion runtime analysis](./analysis/completion_runtime_breakdown.ipynb.ipynb)

These notebooks provide detailed analysis of the completion experiments and their performance across different models and scenarios.

# Packaging the extension

The extension package will produce an extension installer artifact, which can be used to install the vs code extension into any vs code instance. To package the extension, run the following command inside the `root` directory:

    npm run package

This will create a `.vsix` file in the `root` directory. You can install the extension by opening the command palette in Visual Studio Code and running the `Extensions: Install from VSIX...` command. This will open a file dialog where you can select the `.vsix` file. Or you can run the following command in the terminal:

    code --install-extension <path-to-vsix-file>

This will install the extension in your Visual Studio Code instance.

The extension will be activated when you open an Alloy file. The extension will automatically start the language server and connect to it. You can see the logs of the language server in the output panel of Visual Studio Code.
