package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.params.EvaluateSuggestions;
import alloy.language.server.params.SuggestionImpact;
import alloy.language.server.params.responses.AlloyInstanceGraph;
import alloy.language.server.utils.data.ParsingErrorCursor;
import alloy.language.server.visitors.helpers.AlloySyntaxErrorListener;
import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.ErrorWarning;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4viz.VizGUI;
import edu.mit.csail.sdg.ast.Command;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.TranslateAlloyToKodkod;
import org.slf4j.Logger;

import javax.swing.*;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class AlloyInstanceUtils {
	private static final Logger logger = org.slf4j.LoggerFactory.getLogger(AlloyInstanceUtils.class);

	private static final A4Reporter rep = new A4Reporter() {
		@Override
		public void warning(ErrorWarning msg) {
			logger.warn(msg.toString().trim());
		}
	};

	public static CompModule buildAlloyModel(String alloyCode) {
		return buildAlloyModelWithErrorListing(alloyCode).a;
	}

	public static Pair<CompModule, List<ParsingErrorCursor>> buildAlloyModelWithErrorListing(String alloyCode) {
		try {
			StringBuilder sb = new StringBuilder();
			sb.append(alloyCode);
			sb.append("\n").append("run {} for 3");

			String originalText = sb.toString();

			var parser = CodeUtils.buildAlloyParser(originalText);
			parser.removeErrorListeners();
			var syntaxErrorListener = new AlloySyntaxErrorListener();
			parser.addErrorListener(syntaxErrorListener);
			var alloyModule = parser.alloyModule();

			//			var syntaxVisitor = new AlloySyntaxParsingVisitor(syntaxErrorListener.getRemovableRuleContexts());
			//			String curatedSyntax = syntaxVisitor.visitAlloyModule(alloyModule);
			var lines = originalText.split("\n");
			var parsingErrors = syntaxErrorListener.getParsingErrors();
			Set<Integer> errorLines = parsingErrors.stream()
					.flatMap(parsingErrorCursor -> parsingErrorCursor.getErrorLines()
							.stream())
					.collect(Collectors.toSet());

			StringBuilder curatedSyntax = new StringBuilder();
			for (int i = 0; i < lines.length; i++) {
				if (errorLines.contains(i)) {
					curatedSyntax.append("\n");
				} else {
					curatedSyntax.append(lines[i]).append("\n");
				}
			}
			logger.debug(curatedSyntax.toString());
			var compModule = CompUtil.parseEverything_fromString(rep, curatedSyntax.toString());
			return new Pair<>(compModule, syntaxErrorListener.getParsingErrors());
		} catch (Err ex) {
			logger.error("Error parsing Alloy model, error: {}", ex.msg, ex);
			throw ex;
		}
	}

	public static A4Solution buildInstance(CompModule world) {
		int lastCommandIndex = world.getAllCommands().size() - 1;
		Command command = world.getAllCommands().get(lastCommandIndex);
		return buildInstanceFromCommand(world, command);
	}

	public static A4Solution buildInstanceFromCommand(CompModule world, String command) {
		var commandInstance =
				world.getAllCommands().stream().filter(c -> c.toString().equals(command)).findFirst().orElseThrow();
		return buildInstanceFromCommand(world, commandInstance);
	}

	public static A4Solution buildInstanceFromCommand(CompModule world, Command command) {
		try {
			A4Options options = new A4Options();
			options.solver = A4Options.SatSolver.SAT4J;

			return TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), command, options);
		} catch (Err e) {
			logger.error("Error parsing Alloy model, error: {}", e.msg, e);
			throw new RuntimeException(e);
		}
	}

	public static AlloyInstanceGraph getInstanceGraph(CompModule world, A4Solution instance) {
		return getInstanceGraph(world, instance, 0);
	}

	public static AlloyInstanceGraph getInstanceGraph(CompModule world, A4Solution instance, int state) {
		var sigs = world.getAllSigs().makeCopy();
		Set<String> avoidableSigs =
				new HashSet<>(List.of("univ", "Int", "seq/Int", "String", "none", "none/Int", "none/String"));
		Set<String> sigTypes = new HashSet<>();
		Set<AlloyInstanceGraph.Atom> atoms = new HashSet<>();
		Set<AlloyInstanceGraph.Relation> relations = new HashSet<>();
		var instanceAtoms = instance.getAllAtoms();
		for (var atom : instanceAtoms) {
			atoms.add(new AlloyInstanceGraph.Atom(atom.label, atom.type().toString()));
		}
		for (Sig s : sigs) {
			if (avoidableSigs.contains(s.label)) {
				continue;
			}
			if (s.isTopLevel()) {
				sigTypes.add(s.label);
			} else {
				var sigTupleSet = instance.eval(s, state);
				for (var tuple : sigTupleSet) {
					var existingAtom = atoms.stream().filter(a -> a.name.equals(tuple.atom(0))).findFirst();
					existingAtom.ifPresent(atom -> atom.addSubType(s.toString()));
					//				atoms.add(new AlloyInstanceGraph.Atom(tuple.atom(0),
					//				                                      tuple.type().toString().replace("{", "").replace("}", "")));
				}
			}
			for (var f : s.getFields()) {
				var fieldTupleSet = instance.eval(f, state);
				for (var tuple : fieldTupleSet) {
					int arity = tuple.arity();
					var relation = new AlloyInstanceGraph.Relation(CodeUtils.formatLabel(f.label), tuple.atom(0),
							tuple.atom(arity - 1));
					for (int i = 1; i < arity - 1; i++) {
						relation.addIntermediate(tuple.atom(i));
					}
					relations.add(relation);
				}
			}
		}
		return new AlloyInstanceGraph(instance.toString(state), instance.format(state), sigTypes, atoms, relations);
	}

	public static VizGUI showLegacyVisualizer(A4Solution instance, String documentUri) throws IOException {
		if (instance.satisfiable()) {
			System.setProperty("apple.awt.UIElement", "true");
			System.setProperty("apple.awt.application.name", "Alloy Visualizer");
			System.setProperty("apple.laf.useScreenMenuBar", "false");
			System.setProperty("com.apple.mrj.application.apple.menu.about.name", "Alloy Visualizer");

			File tempFile = File.createTempFile(documentUri, "-xml-output.xml");
			tempFile.deleteOnExit(); // Fallback cleanup mechanism
			String xmlOutputFileName = tempFile.getAbsolutePath();
			logger.info("Writing XML file: {}", xmlOutputFileName);
			instance.writeXML(xmlOutputFileName);

			CompletableFuture<VizGUI> vizFuture = new CompletableFuture<>();

			SwingUtilities.invokeLater(() -> {
				try {
					VizGUI viz = new VizGUI(false, xmlOutputFileName, null);

					// Important: Set type before the frame is visible
					var frame = viz.getFrame();

					// Now make it visible and manage focus
					frame.setAlwaysOnTop(true);
					frame.setVisible(true);
					frame.toFront();
					frame.setFocusableWindowState(true);
					frame.setAlwaysOnTop(false);


					// Add both windowClosed and windowClosing listeners
					viz.getFrame().addWindowListener(new java.awt.event.WindowAdapter() {
						@Override
						public void windowClosed(java.awt.event.WindowEvent e) {
							handleWindowClose(xmlOutputFileName);
						}

						@Override
						public void windowClosing(java.awt.event.WindowEvent e) {
							handleWindowClose(xmlOutputFileName);
						}

						private void handleWindowClose(String fileName) {
							logger.info("Visualizer window closing/closed. Scheduling file deletion: {}", fileName);

							// Use a scheduled executor to retry deletion a few times
							Thread cleanupThread = new Thread(() -> {
								for (int attempt = 1; attempt <= 5; attempt++) {
									try {
										Thread.sleep(200 * attempt);
										File file = new File(fileName);

										if (!file.exists()) {
											logger.info("File already deleted: {}", fileName);
											break;
										}

										boolean deleted = file.delete();
										if (deleted) {
											logger.info("Successfully deleted file: {}", fileName);
											break;
										} else {
											logger.warn("Deletion attempt {} failed. Will retry.", attempt);
										}
									} catch (Exception ex) {
										logger.error("Error during deletion attempt {}: {}", attempt, ex.toString(),
												ex);
									}
								}
							});

							cleanupThread.setDaemon(true);
							cleanupThread.start();
						}
					});

					vizFuture.complete(viz);
				} catch (Exception e) {
					vizFuture.completeExceptionally(e);
					logger.error("Error creating visualizer: {}", e.getMessage(), e);
					// Try to delete the file if visualization fails
					new File(xmlOutputFileName).delete();
				}
			});

			try {
				return vizFuture.get(3, TimeUnit.SECONDS);
			} catch (Exception e) {
				logger.error("Error creating visualizer: {}", e.getMessage(), e);
				// Try to delete the file if timeout occurs
				new File(xmlOutputFileName).delete();
				return null;
			}
		}
		return null;
	}

	public static SuggestionImpact.SuggestionImpactResponse getSuggestionImpact(CompModule world,
	                                                                            String baseline,
	                                                                            String suggestedExpression) {
		String A_and_B = makeFormulaComparingCommandExpression(baseline, false, suggestedExpression, false, "and");
		Boolean A_and_BImpact = evalExpressionAsCommand(world, A_and_B);
		String A_and_notB = makeFormulaComparingCommandExpression(baseline, false, suggestedExpression, true, "and");
		Boolean A_and_notBImpact = evalExpressionAsCommand(world, A_and_notB);
		String notA_and_B = makeFormulaComparingCommandExpression(baseline, true, suggestedExpression, false, "and");
		Boolean notA_and_BImpact = evalExpressionAsCommand(world, notA_and_B);
		String notA_and_notB = makeFormulaComparingCommandExpression(baseline, true, suggestedExpression, true, "and");
		Boolean notA_and_notBImpact = evalExpressionAsCommand(world, notA_and_notB);

		String A_iff_B = makeFormulaComparingCommandExpression(baseline, false, suggestedExpression, false, "<=>");
		Boolean A_iff_BImpact = evalExpressionAsCommand(world, A_iff_B);

		return new SuggestionImpact.SuggestionImpactResponse(baseline, suggestedExpression, A_iff_BImpact,
				A_and_BImpact, notA_and_BImpact, A_and_notBImpact,
				notA_and_notBImpact);
	}

	private static String makeFormulaComparingCommandExpression(String baseline,
	                                                            boolean negateBaseline,
	                                                            String suggestedExpression,
	                                                            boolean negateSuggestion,
	                                                            String operator) {
		StringBuilder sb = new StringBuilder();
		if (negateBaseline) {
			sb.append("!(").append(baseline).append(")");
		} else {
			sb.append("(").append(baseline).append(")");
		}
		sb.append(" ").append(operator).append(" ");
		if (negateSuggestion) {
			sb.append("!(").append(suggestedExpression).append(")");
		} else {
			sb.append("(").append(suggestedExpression).append(")");
		}
		return sb.toString();
	}

	private static Boolean evalExpressionAsCommand(CompModule world, String expression) {
		try {
			var checkExpr = world.parseOneExpressionFromString(expression);
			for (var fact : world.getAllFacts()) {
				checkExpr = checkExpr.and(fact.b);
			}
			var command = new Command(false, -1, -1, -1, checkExpr);
			var instance = AlloyInstanceUtils.buildInstanceFromCommand(world, command);
			return instance.satisfiable();
		} catch (Exception e) {
			logger.error("Error parsing baseline expression {}", e.getMessage());
			return null;
		}
	}

	public static Boolean matchesSyntactically(CompModule world,
	                                           String originalExpression,
	                                           String suggestedExpression) {
		try {
			var original = world.parseOneExpressionFromString(originalExpression);
			var suggested = world.parseOneExpressionFromString(suggestedExpression);
			return original.toString().equals(suggested.toString());
		} catch (Exception e) {
			logger.error("Error parsing baseline expression {}", e.getMessage());
			return null;
		}
	}

	public static Boolean matchesFormula(CompModule model, String originalExpression, String suggestedExpression) {
		var comparisonCommand =
				makeFormulaComparingCommandExpression(originalExpression, false, suggestedExpression, true, "<=>");
		return evalExpressionAsCommand(model, comparisonCommand);
	}

	public static EvaluateSuggestions.EvaluateSuggestionsResponse evaluateSuggestions(CompModule world,
	                                                                                  String incompleteExpression,
	                                                                                  List<String> suggestions,
	                                                                                  String expectedTerm,
																					  String remainingText,
																					  String extractedExpectedTerm,
	                                                                                  Map<String, alloyParser.ExprContext> quantifiers) {
		List<EvaluateSuggestions.SuggestionEvaluation> evaluations = new ArrayList<>();
		String quantifierPrefix = AlloyExpressionParsingUtils.buildQuantifierPrefix(quantifiers);
		for (int i = 0; i < suggestions.size(); i++) {
			String suggestion = suggestions.get(i);

			// Matching metrics
			boolean matchesExactly = extractedExpectedTerm.trim().equals(suggestion.trim());
			var matchesSyntactically =
					AlloyInstanceUtils.matchesSyntactically(world, quantifierPrefix + extractedExpectedTerm, quantifierPrefix + suggestion);

			var originalExpression = incompleteExpression + " " + extractedExpectedTerm;
			var suggestedExpression = incompleteExpression + " " + suggestion;
			var matchesSemantically = AlloyInstanceUtils.matchesFormula(world, originalExpression, suggestedExpression);

			// Expression Components
			var signatures = extractSignatures(world);
			var relations = extractRelations(world);
			var variables = quantifiers.keySet();
			List<EvaluateSuggestions.ExpressionComponent> expressionComponents = AlloyExpressionParsingUtils.extractExpressionComponents(suggestion, signatures, relations, variables);

			evaluations.add(new EvaluateSuggestions.SuggestionEvaluation(suggestion, i + 1, matchesExactly,
					matchesSyntactically, matchesSemantically, expressionComponents));
		}
		return new EvaluateSuggestions.EvaluateSuggestionsResponse(evaluations);
	}

	public static Set<String> extractSignatures(CompModule world) {
		return world.getAllSigs().makeConstList().stream()
				.map(CodeUtils::formatLabel)
				.collect(Collectors.toSet());
	}

	public static Set<String> extractRelations(CompModule world) {
		return world.getAllSigs().makeConstList().stream().flatMap(s -> s.getFields().makeConstList().stream())
				.map(CodeUtils::formatLabel)
				.collect(Collectors.toSet());
	}

	public static EvaluateSuggestions.ExpressionComponent.ComponentType determineComponentType(String component, Set<String> signatures, Set<String> relations, Set<String> quantifiers) {
		if (signatures.contains(component)) {
			return EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE;
		} else if (relations.contains(component)) {
			return EvaluateSuggestions.ExpressionComponent.ComponentType.RELATION;
		} else if (quantifiers.contains(component)) {
			return EvaluateSuggestions.ExpressionComponent.ComponentType.VARIABLE;
		} else if (CodeUtils.SET_OPERATORS.contains(component) || CodeUtils.UNARY_OPERATORS.contains(component) || CodeUtils.LOGICAL_OPERATORS.contains(component)) {
			return EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR;
		} else {
			return EvaluateSuggestions.ExpressionComponent.ComponentType.CONSTANT;
		}
	}
}
