# Architecture

The client source code is located in the [`client`](./client) directory, while the server source code is in the [`server`](./server) directory.

## Client

The client controls the behaviors of the VSCode editor. The entrypoint of the client is the [`extension.ts`](./client/src/extension.ts) file.

Major functionalities of the `extension.ts` file include:

- Activate the extension
    - Spawn the language server backend
    - Initialize the language client
- Register custom commands with commandId and handler function

Custom commands are defined in the [`client/src/commands-handlers.ts`](./client/src/commands-handlers.ts) file. Commands are important part of the [API workflow](#api-workflow).

## Server

The server's entrypoint is the [`ServerApplication.java`](./server/src/main/java/alloy/language/server/ServerApplication.java) file. There are some config flags for switching specific features, such as:

- STDIN or socket communication mode
- Switch between formula completion or generator suggestion
- Other less important features

It initiates the [`AlloyLanguageServer.java`](./server/src/main/java/alloy/language/server/AlloyLanguageServer.java) file, which defines the language server capabilities.

All of the implementations are developed inside the [`AlloyTextDocumentService.java`](./server/src/main/java/alloy/language/server/AlloyTextDocumentService.java) file.

### Completion API
 For completion, the `public CompletableFuture<Either<List<CompletionItem>, CompletionList>> completion(CompletionParams completionParams)` method is implemented.

### Suggestion Impact API
The `public CompletableFuture<Either<List<SuggestionImpactItem>, SuggestionImpactList>> suggestionImpact(SuggestionImpactParams suggestionImpactParams)` method is implemented.

This is a custom api which is not included in the official LSP specification.

### Evaluate Suggestion API
The `public CompletableFuture<Either<List<EvaluateSuggestionItem>, EvaluateSuggestionList>> evaluateSuggestion(EvaluateSuggestionParams evaluateSuggestionParams)` method is implemented. This is also a custom API which is not included in the official LSP specification.

## API workflow

All the api calls are initiated as command calls registered in the [`client/src/extension.ts`](./client/src/extension.ts) file. Each command has a mapping with the server entrypoints. The server entrypoints are defined in the [`AlloyTextDocumentService.java`](./server/src/main/java/alloy/language/server/AlloyTextDocumentService.java) file.

Important mappings:

| Command ID | Server Entrypoint |
|------------|-------------------|
| `vscode.executeCompletionItemProvider` | `completion(CompletionParams completionParams)` |
| `alloy.suggestionImpact` | `suggestionImpact(SuggestionImpactParams suggestionImpactParams)` |
| `alloy.evaluateSuggestions` | `evaluateSuggestion(EvaluateSuggestionParams evaluateSuggestionParams)` |