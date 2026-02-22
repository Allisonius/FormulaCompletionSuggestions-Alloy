package alloy.language.server;

import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.params.EvaluateSuggestions;
import alloy.language.server.params.ModelStats;
import alloy.language.server.params.SuggestionImpact.SuggestionImpactParams;
import alloy.language.server.params.SuggestionImpact.SuggestionImpactResponse;
import alloy.language.server.params.requests.AlloyCompletionItemSelectedParams;
import alloy.language.server.params.requests.AlloyInstanceParams;
import alloy.language.server.params.requests.AlloyLegacyVizParams;
import alloy.language.server.params.responses.AlloyInstanceGraph;
import alloy.language.server.utils.*;
import alloy.language.server.visitors.BaselineExpressionExtractorVisitor;
import alloy.language.server.visitors.IncompleteBlockRangeExtractorVisitor;
import alloy.language.server.visitors.completions.AlloyCompletionVisitorDispatcher;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import edu.mit.csail.sdg.alloy4viz.VizGUI;
import edu.mit.csail.sdg.ast.Command;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.translator.A4Solution;
import org.eclipse.lsp4j.*;
import org.eclipse.lsp4j.jsonrpc.CompletableFutures;
import org.eclipse.lsp4j.jsonrpc.messages.Either;
import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.slf4j.Logger;

import java.io.IOException;
import java.sql.Time;
import java.time.Duration;
import java.time.temporal.TemporalUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

public class AlloyTextDocumentService implements TextDocumentService {
	private static final Logger logger = org.slf4j.LoggerFactory.getLogger(AlloyTextDocumentService.class);
	private final AlloyLanguageServer languageServer;

	private final Map<String, AlloyDocumentModel> openedDocuments;
	// TODO 5/10/25: Make the map <<DocumentURI, Command>, A4Solution>
	private final Map<String, A4Solution> openInstances;
	private VizGUI currentLegacySolutionGUI = null;

	public AlloyTextDocumentService(AlloyLanguageServer languageServer) {
		this.languageServer = languageServer;
		openedDocuments = new ConcurrentHashMap<>();
		this.openInstances = new ConcurrentHashMap<>();
	}

	private void updateOpenedDocumentSet(TextDocumentItem textDocumentItem) {
		updateOpenedDocumentSet(textDocumentItem.getUri(), textDocumentItem.getText());
	}

	private void removeOpenedDocumentSet(String uri) {
		openedDocuments.remove(uri);
	}

	private void updateOpenedDocumentSet(String uri, String documentText) {
		if (openedDocuments.containsKey(uri)) {
			AlloyDocumentModel documentModel = openedDocuments.get(uri);
			documentModel.documentChanged(documentText);
			openedDocuments.put(uri, documentModel);
			logger.info("Updated existing document");
		} else {
			AlloyDocumentModel documentModel = new AlloyDocumentModel(uri, documentText, languageServer.getClient());
			openedDocuments.put(uri, documentModel);
			logger.info("Created new document");
		}
	}

	@Override
	public void didOpen(DidOpenTextDocumentParams didOpenTextDocumentParams) {
		updateOpenedDocumentSet(didOpenTextDocumentParams.getTextDocument());
	}

	@Override
	public void didChange(DidChangeTextDocumentParams didChangeTextDocumentParams) {
		updateOpenedDocumentSet(didChangeTextDocumentParams.getTextDocument().getUri(),
		                        didChangeTextDocumentParams.getContentChanges().get(0).getText());
	}

	@Override
	public void didClose(DidCloseTextDocumentParams didCloseTextDocumentParams) {
		removeOpenedDocumentSet(didCloseTextDocumentParams.getTextDocument().getUri());
	}

	@Override
	public void didSave(DidSaveTextDocumentParams didSaveTextDocumentParams) {
	}

	private CodeLens buildCodeLens(Command command, boolean isNextInstance) {
		CodeLens codeLens = new CodeLens();
		codeLens.setRange(CodeUtils.getRangeFromPos(command.pos()));
		if (!isNextInstance) {
			String commandTitle = command.check ? "Check command" : "Run command";
			org.eclipse.lsp4j.Command vscodeCommand =
					new org.eclipse.lsp4j.Command(commandTitle, "alloy.showLegacyView", List.of(command.toString()));
			codeLens.setCommand(vscodeCommand);
		} else {
			String commandTitle = command.check ? "New counterexample" : "New solution";
			org.eclipse.lsp4j.Command vscodeCommand =
					new org.eclipse.lsp4j.Command(commandTitle, "alloy.showLegacyView",
					                              List.of(command.toString(), Boolean.toString(true)));
			codeLens.setCommand(vscodeCommand);
		}

		return codeLens;
	}

	@Override
	public CompletableFuture<List<? extends CodeLens>> codeLens(CodeLensParams params) {
		return CompletableFutures.computeAsync(cancelChecker -> {
			AlloyDocumentModel documentModel = openedDocuments.get(params.getTextDocument().getUri());
			if (documentModel == null || documentModel.hasErrors()) {
				return List.of();
			}
			var world = documentModel.getModel();
			var commands = world.getAllCommands();
			List<CodeLens> codeLensList = new ArrayList<>();
			for (Command command : commands) {
				codeLensList.add(buildCodeLens(command, false));
				codeLensList.add(buildCodeLens(command, true));
			}
			return codeLensList;
		});
	}

	@Override
	public CompletableFuture<Either<List<CompletionItem>, CompletionList>> completion(CompletionParams completionParams) {
		CompletableFuture<Either<List<CompletionItem>, CompletionList>> future =
				CompletableFutures.computeAsync(cancelChecker -> {
					long startTime = System.currentTimeMillis();
					String uri = completionParams.getTextDocument().getUri();
					AlloyDocumentModel documentModel = openedDocuments.get(uri);
					String documentText = documentModel.getDocumentText();

					// Whitewash the document text after the completion position till the end of the block
					var parser = CodeUtils.buildAlloyParser(documentText);
					var tree = parser.alloyModule();
					IncompleteBlockRangeExtractorVisitor incompleteBlockRangeExtractorVisitor =
							new IncompleteBlockRangeExtractorVisitor(documentText, completionParams.getPosition());
					Range incompleteBlockRange = incompleteBlockRangeExtractorVisitor.visit(tree);
					if (incompleteBlockRange != null) {
						TextEditor editor = new TextEditor(documentText);
						documentText = editor.getWhiteWashedText(incompleteBlockRange);
					}

					cancelChecker.checkCanceled();
					CompModule model = documentModel.getModel();
					A4Solution instance = documentModel.getDefaultSolution();
					try {
						AlloyEvaluation alloyEvaluation = new AlloyEvaluation(model, instance);
						cancelChecker.checkCanceled();
						AlloyCompletionVisitorDispatcher visitors =
								new AlloyCompletionVisitorDispatcher(alloyEvaluation);
						parser = CodeUtils.buildAlloyParser(documentText);
						tree = parser.alloyModule();
						// TODO: visitors might not need the alloy text, only the parse tree is needed
						long preprocessingTime = System.currentTimeMillis() - startTime;
						List<CompletionItem> completionItems =
								visitors.visitAndBuildCompletions(documentText, completionParams, tree);
						if (ConfigManager.getInstance().useNewCompletionProvider()) {
							var timingCompletionItem = completionItems.stream().filter(item -> item.getLabel().equals("<TIME>")).findFirst();
							timingCompletionItem.ifPresent(completionItem -> completionItem.setInsertText(Long.toString(preprocessingTime)));
						}
						return Either.forLeft(completionItems);
					} catch (Exception e) {
						logger.error("Error for completion params:", e);
						logger.error(completionParams.toString());
						throw e;
					}
				});

		return future.completeOnTimeout(Either.forLeft(List.of()), 10000, TimeUnit.MILLISECONDS);
	}

	@JsonRequest(value = "alloy/getInstance", useSegment = false)
	public CompletableFuture<AlloyInstanceGraph> getInstance(JsonObject alloyInstanceParams) {
		logger.info("GET INSTANCE");
		AlloyInstanceParams instanceParams = new Gson().fromJson(alloyInstanceParams, AlloyInstanceParams.class);
		var documentModel = openedDocuments.get(instanceParams.getDocumentUri());
		var world = documentModel.getModel();
		logger.info("Instance params: {}", instanceParams);
		return CompletableFuture.supplyAsync(() -> {
			A4Solution instance;
			try {
				if (instanceParams.getCommand().isEmpty()) {
					instance = AlloyInstanceUtils.buildInstance(world);
				} else {
					instance = AlloyInstanceUtils.buildInstanceFromCommand(world, instanceParams.getCommand());
				}
			} catch (Exception e) {
				logger.error("Error building instance", e);
				throw new RuntimeException(e);
			}
			openInstances.put(instanceParams.getDocumentUri(), instance);
			return AlloyInstanceUtils.getInstanceGraph(world, instance);
		});
	}

	@JsonRequest(value = "alloy/nextInstance", useSegment = false)
	public CompletableFuture<AlloyInstanceGraph> nextInstance(JsonObject alloyInstanceParams) {
		logger.info("NEXT INSTANCE");
		AlloyInstanceParams instanceParams = new Gson().fromJson(alloyInstanceParams, AlloyInstanceParams.class);
		var documentModel = openedDocuments.get(instanceParams.getDocumentUri());
		var world = documentModel.getModel();
		logger.info("Next instance params: {}", instanceParams);
		return CompletableFuture.supplyAsync(() -> {
			A4Solution instance = openInstances.get(instanceParams.getDocumentUri());
			if (instance == null) {
				logger.warn("No previous instance found, creating new one");
				try {
					if (instanceParams.getCommand().isEmpty()) {
						instance = AlloyInstanceUtils.buildInstance(world);
					} else {
						instance = AlloyInstanceUtils.buildInstanceFromCommand(world, instanceParams.getCommand());
					}
				} catch (Exception e) {
					logger.error("Error building instance", e);
					throw new RuntimeException(e);
				}
			}
			var nextInstance = instance.next();
			if (nextInstance == null) {
				logger.info("No more instances");
				nextInstance = instance;
			}
			openInstances.put(instanceParams.getDocumentUri(), nextInstance);
			return AlloyInstanceUtils.getInstanceGraph(world, nextInstance);
		});
	}

	@JsonRequest(value = "alloy/legacyVizViewer", useSegment = false)
	public CompletableFuture<Void> legacyVizViewer(JsonObject legacyVizViewerParams) {
		logger.info("LEGACY VIZ VIEWER");
		AlloyLegacyVizParams legacyVizParams = new Gson().fromJson(legacyVizViewerParams, AlloyLegacyVizParams.class);
		var documentModel = openedDocuments.get(legacyVizParams.getDocumentUri());
		var world = documentModel.getModel();
		logger.info("Instance params: {}", legacyVizParams);
		return CompletableFuture.supplyAsync(() -> {
			A4Solution instance;
			if (legacyVizParams.isNextInstance() && openInstances.containsKey(legacyVizParams.getDocumentUri()) &&
			    openInstances.get(legacyVizParams.getDocumentUri()) != null) {
				instance = openInstances.get(legacyVizParams.getDocumentUri());
				logger.info("Getting next instance");
				var nextInstance = instance.next();
				if (nextInstance == null) {
					logger.info("No more instances");
					nextInstance = instance;
				}
				openInstances.put(legacyVizParams.getDocumentUri(), nextInstance);
				instance = nextInstance;
			} else {
				logger.warn("No previous instance found, creating new one");
				try {
					if (legacyVizParams.getCommand() == null || legacyVizParams.getCommand().isEmpty()) {
						instance = AlloyInstanceUtils.buildInstance(world);
					} else {
						instance = AlloyInstanceUtils.buildInstanceFromCommand(world, legacyVizParams.getCommand());
					}
				} catch (Exception e) {
					logger.error("Error building instance", e);
					throw new RuntimeException(e);
				}
				openInstances.put(legacyVizParams.getDocumentUri(), instance);
			}
			if (instance.satisfiable()) {
				try {
					logger.info("Showing legacy visualizer");
					if (currentLegacySolutionGUI != null) {
						currentLegacySolutionGUI.getFrame().dispose();
					}
					currentLegacySolutionGUI =
							AlloyInstanceUtils.showLegacyVisualizer(instance, legacyVizParams.getDocumentUri());
				} catch (IOException e) {
					logger.error("Error showing legacy visualizer", e);
					throw new RuntimeException(e);
				}
			} else {
				logger.info("No satisfiable instance found");
				var client = languageServer.getClient();
				var message = switch (instance.getOriginalCommand()) {
					case String cmd when cmd.startsWith("Check") -> "No counterexamples found.";
					default -> "No satisfiable instance found.";
				};
				client.showMessage(new MessageParams(MessageType.Warning, message));
			}
			return null;
		});
	}

	@JsonRequest(value = "alloy/completionItemSelected", useSegment = false)
	public CompletableFuture<AlloyInstanceGraph> completionItemSelected(JsonObject completionItemSelectedParams) {
		logger.info("COMPLETION ITEM SELECTED");
		AlloyCompletionItemSelectedParams params =
				new Gson().fromJson(completionItemSelectedParams, AlloyCompletionItemSelectedParams.class);
		logger.info(params.getTextDocument().getUri());
		logger.info(params.getSelectedCompletionInfo().getText());
		logger.info(params.getPosition().toString());
		return CompletableFutures.computeAsync(cancelChecker -> {
			//			String document = openDirtyDocuments.get(params.getTextDocument().getUri());

			// Build the alloy evaluation without the completion line = position.line
			// Append the selected text to the document and build the alloy evaluation
			//			String documentText = openDirtyDocuments.get(documentUri);
			//			AlloyEvaluation alloyEvaluation = new AlloyEvaluation(documentText);
			//			return alloyEvaluation.getInstanceGraph();
			return null;
		});
	}

	@JsonRequest(value = "alloy/suggestionImpact", useSegment = false)
	public CompletableFuture<SuggestionImpactResponse> suggestionImpact(JsonObject suggestionImpactParams) {
		logger.info("SUGGESTION IMPACT");
		SuggestionImpactParams suggestionImpact =
				new Gson().fromJson(suggestionImpactParams, SuggestionImpactParams.class);
		return CompletableFutures.computeAsync(cancelChecker -> {
			logger.info("Incomplete Formula: {}", suggestionImpact.incompleteFormula());
			logger.info("Suggestion: {}", suggestionImpact.suggestion());
			logger.info("Position: {}", suggestionImpact.position());

			AlloyDocumentModel documentModel = openedDocuments.get(suggestionImpact.documentUri());
			String documentText = documentModel.getDocumentText();
			var parser = CodeUtils.buildAlloyParser(documentText);
			var tree = parser.alloyModule();
			IncompleteBlockRangeExtractorVisitor incompleteBlockRangeExtractorVisitor =
					new IncompleteBlockRangeExtractorVisitor(documentText, suggestionImpact.position());
			Range incompleteBlockRange = incompleteBlockRangeExtractorVisitor.visit(tree);
			if (incompleteBlockRange != null) {
				TextEditor editor = new TextEditor(documentText);
				documentText = editor.getWhiteWashedText(incompleteBlockRange);
			}
			cancelChecker.checkCanceled();

			BaselineExpressionExtractorVisitor baselineExtractor =
					new BaselineExpressionExtractorVisitor(documentText, suggestionImpact.position());
			parser = CodeUtils.buildAlloyParser(documentText);
			tree = parser.alloyModule();
			String baseline = baselineExtractor.visit(tree);
			if (baseline == null || baseline.isEmpty()) {
				logger.warn("No baseline found for suggestion impact");
				baseline = "{}";
				//				return new SuggestionImpactResponse(baseline, null,null, null, null, null, null);
			}
			logger.info("Baseline: {}", baseline);
			String suggestedExpression = suggestionImpact.incompleteFormula() + suggestionImpact.suggestion();
			logger.info("Formula with suggestion: {}", suggestedExpression);
			var world = documentModel.getModel();
			cancelChecker.checkCanceled();
			SuggestionImpactResponse response =
					AlloyInstanceUtils.getSuggestionImpact(world, baseline, suggestedExpression);
			return response;
		});
	}

	@JsonRequest(value = "alloy/evaluateSuggestions", useSegment = false)
	public CompletableFuture<EvaluateSuggestions.EvaluateSuggestionsResponse> evaluateSuggestions(JsonObject evaluateSuggestionsParams) {
		logger.info("EVALUATE SUGGESTIONS");
		EvaluateSuggestions.EvaluateSuggestionsParams params =
				new Gson().fromJson(evaluateSuggestionsParams, EvaluateSuggestions.EvaluateSuggestionsParams.class);
		return CompletableFutures.computeAsync(cancelChecker -> {
			if (params.suggestions().isEmpty()) return new EvaluateSuggestions.EvaluateSuggestionsResponse(List.of(), null, null);
			AlloyDocumentModel documentModel = openedDocuments.get(params.documentUri());
			String documentText = documentModel.getDocumentText();
			var parser = CodeUtils.buildAlloyParser(documentText);
			var tree = parser.alloyModule();
			IncompleteBlockRangeExtractorVisitor incompleteBlockRangeExtractorVisitor =
					new IncompleteBlockRangeExtractorVisitor(documentText, params.position());
			Range incompleteBlockRange = incompleteBlockRangeExtractorVisitor.visit(tree);
			if (incompleteBlockRange != null) {
				TextEditor editor = new TextEditor(documentText);
				documentText = editor.getWhiteWashedText(incompleteBlockRange);
			}
			cancelChecker.checkCanceled();
			var dummyCompletionParams =
					new CompletionParams(new TextDocumentIdentifier(documentModel.getDocumentURI()), params.position(),
					                     new CompletionContext());
			Map<String, alloyParser.ExprContext> quantifiers =
					AlloyExpressionParsingUtils.extractDeclaredVariables(documentModel.getDocumentText(),
					                                                     dummyCompletionParams, tree);
			cancelChecker.checkCanceled();
			alloyParser.ExprContext ctx = CodeUtils.buildAlloyParser(params.incompleteExpression()).expr();
			var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(ctx, quantifiers);
			var mergedQuantifiers = new ConcurrentHashMap<>(quantifiers);
			mergedQuantifiers.putAll(declaredVariables);

			String extractedExpectedTerm = AlloyExpressionParsingUtils.findLeadingExpression(params.remainingText());
			if (extractedExpectedTerm == null) {
				extractedExpectedTerm = params.expectedTerm();
			}
			return AlloyInstanceUtils.evaluateSuggestions(documentModel.getModel(), params.incompleteExpression(),
			                                              params.suggestions(), params.expectedTerm(), params.remainingText(), extractedExpectedTerm, mergedQuantifiers);
		});
	}

	@JsonRequest(value = "alloy/getModelStats", useSegment = false)
	public CompletableFuture<ModelStats.ModelStatsResponse> modelStates(JsonObject modelStatsParams) {
		logger.info("MODEL STATS");
		ModelStats.ModelStatsRequest params = new Gson().fromJson(modelStatsParams, ModelStats.ModelStatsRequest.class);
		return CompletableFutures.computeAsync(cancelChecker -> {
			AlloyDocumentModel documentModel = openedDocuments.get(params.documentUri());
			return AlloyInstanceUtils.modelStats(documentModel);
		});
	}
}
