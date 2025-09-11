package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.suggestions.ArityMatchingSuggestions;
import alloy.language.server.suggestions.RelationalGraphSuggestions;
import alloy.language.server.suggestions.StaticSuggestionsPool;
import alloy.language.server.utils.data.EvaluationResult;
import alloy.language.server.utils.data.SuggestionTerm;
import arepair.generator.CompatUtils;
import edu.mit.csail.sdg.ast.Expr;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.A4TupleSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class AlloyEvaluation {

	private static final Logger logger = LoggerFactory.getLogger(AlloyEvaluation.class);

	private final CompModule world;
	private final A4Solution instance;
	private final StaticSuggestionsPool staticSuggestionsPool;
	private final ArityMatchingSuggestions arityMatchingSuggestions;
	private final RelationalGraphSuggestions relationalGraphSuggestions;

	public AlloyEvaluation(CompModule world, A4Solution instance) {
		this.world = world;
		this.instance = instance;
		this.staticSuggestionsPool = new StaticSuggestionsPool(world);
		this.relationalGraphSuggestions = new RelationalGraphSuggestions(world);
		this.arityMatchingSuggestions = new ArityMatchingSuggestions(world, staticSuggestionsPool);
	}

	public CompModule getWorld() {
		return world;
	}

	public A4Solution getInstance() {
		return instance;
	}

	public List<SuggestionTerm> getApplicableSuggestions() {
		return staticSuggestionsPool.fromSignatures();
	}

	public List<String> getAllSigs() {
		//		return world.getAllSigs().makeCopy().stream().map(CodeUtils::formatLabel).collect(Collectors.toList());
		return world.getAllReachableSigs().stream().map(CodeUtils::formatLabel).collect(Collectors.toList());
	}

	public List<SuggestionTerm> getAllSigsAsSuggestions() {
		return world.getAllReachableSigs()
				.stream()
				.filter(sig -> !sig.label.equals("seq/Int"))
				.map(sig -> new SuggestionTerm(CodeUtils.formatLabel(sig.label), sig.type(),
						sig.builtin ? SuggestionTerm.Degree.BUILT_IN :
								SuggestionTerm.Degree.SIG))
				.collect(Collectors.toList());
	}

	public List<String> getAllAtoms() {
		return Stream.of(instance.getAllAtoms()).map(Object::toString).collect(Collectors.toList());
	}

	public Boolean evalBoolean(String expression) {
		try {
			Expr expr = world.parseOneExpressionFromString(expression);
			var evalResult = instance.eval(expr);
			if (evalResult instanceof Boolean) {
				return ((Boolean) evalResult);
			}
		} catch (Exception e) {
			// ignore
		}
		return Boolean.FALSE;
	}

	public A4TupleSet evalTupleSet(String expression) {
		try {
			Expr expr = world.parseOneExpressionFromString(expression);
			var evalResult = instance.eval(expr);
			if (evalResult instanceof A4TupleSet) {
				return ((A4TupleSet) evalResult);
			}
		} catch (Exception e) {
			// ignore
		}
		return null;
	}

	public List<EvaluationResult> eval(String incompleteExpression,
	                                   String completionTriggerTerm,
	                                   Map<String, alloyParser.ExprContext> quantifiers) {
		List<EvaluationResult> results = new ArrayList<>();
		String completionExpression = incompleteExpression + completionTriggerTerm;
		for (var suggestion : staticSuggestionsPool.fromSignatures()) {
			try {
				Expr expr = world.parseOneExpressionFromString(completionExpression + suggestion.getLabel());
				var evalResult = instance.eval(expr);
				if (evalResult instanceof A4TupleSet && ((A4TupleSet) evalResult).size() > 0) {
					results.add(new EvaluationResult(suggestion.getLabel(), (A4TupleSet) evalResult, false,
							suggestion.getSortKey()));
				}
				if (evalResult instanceof Boolean && ((Boolean) evalResult)) {
					results.add(new EvaluationResult(suggestion.getLabel(), null, true, suggestion.getSortKey()));
				}
			} catch (Exception e) {
				// ignore
			}
		}
		for (var quantifier : quantifiers.entrySet()) {
			try {
				Expr expr = world.parseOneExpressionFromString(completionExpression + quantifier.getValue().getText());
				var evalResult = instance.eval(expr);
				if (evalResult instanceof A4TupleSet && ((A4TupleSet) evalResult).size() > 0) {
					results.add(new EvaluationResult(quantifier.getKey(), (A4TupleSet) evalResult, false,
							String.valueOf(SuggestionTerm.Degree.QUANTIFIER.ordinal())));
				} else if (evalResult instanceof Boolean && ((Boolean) evalResult)) {
					results.add(new EvaluationResult(quantifier.getKey(), null, true,
							String.valueOf(SuggestionTerm.Degree.QUANTIFIER.ordinal())));
				}
			} catch (Exception e) {
				// ignore
			}
		}

		//		try {
		//			var incompleteExprType = world.parseOneExpressionFromString(incompleteExpression).type();
		//			var initialSuggestions = new SuggestionTerm(incompleteExpression, incompleteExprType, incompleteExprType.arity() == 1 ? SuggestionTerm.Degree.SIG : SuggestionTerm.Degree.RELATION);
		//			var relationalSuggestions = relationalGraphSuggestions.buildForwardSuggestions(incompleteExprType,
		//			                                                                               quantifiers);
		//			for (var suggestion : relationalSuggestions) {
		//				try {
		//					Expr expr = world.parseOneExpressionFromString(completionExpression + suggestion.getLabel());
		//					var evalResult = instance.eval(expr);
		//					if (evalResult instanceof A4TupleSet && ((A4TupleSet) evalResult).size() > 0) {
		//						results.add(new EvaluationResult(suggestion.getLabel(), (A4TupleSet) evalResult, false,
		//						                                 suggestion.getSortKey()));
		//					} else if (evalResult instanceof Boolean && ((Boolean) evalResult)) {
		//						results.add(new EvaluationResult(suggestion.getLabel(), null, true, suggestion.getSortKey()));
		//					}
		//				} catch (Exception e) {
		//					e.printStackTrace();
		//				}
		//			}
		//		} catch (IOException e) {
		//			e.printStackTrace();
		//		}

		return results.stream().distinct().collect(Collectors.toList());
	}


	//	public List<EvaluationResult> evalDot(String type, Map<String, alloyParser.ExprContext> quantifiers) {
	//		return eval(type, ".", quantifiers);
	//	}

	public List<EvaluationResult> evalDot(String expression, Map<String, alloyParser.ExprContext> quantifiers) {
		try {
			var type = world.parseOneExpressionFromString(expression).type();
			var degree = type.arity() == 1 ? SuggestionTerm.Degree.SIG : SuggestionTerm.Degree.RELATION;
			var startingSuggestion = new SuggestionTerm(expression, type, degree, CompatUtils.createExpression(expression, type));
			var suggestions = relationalGraphSuggestions.buildForwardSuggestions(startingSuggestion, quantifiers);
			return suggestions.stream()
					.filter(suggestion -> !CodeUtils.formatLabel(suggestion.getLabel()).equals(expression))
					.map(suggestion -> new EvaluationResult(suggestion.getLabel(),
							suggestion.getSortKey()))
					.collect(Collectors.toList());
		} catch (IOException e) {
			logger.error(e.getMessage());
			return List.of();
		}
	}

	public List<EvaluationResult> evalIntersection(String type, Map<String, alloyParser.ExprContext> quantifiers) {
		List<EvaluationResult> results = eval(type, " & ", quantifiers);
		return results.stream()
				.filter(result -> !CodeUtils.formatLabel(result.getValue()).equals(type))
				.collect(Collectors.toList());
	}

	public List<EvaluationResult> evalUnion(String type, Map<String, alloyParser.ExprContext> quantifiers) {
		List<EvaluationResult> results = eval(type, " + ", quantifiers);
		return results.stream()
				.filter(result -> !CodeUtils.formatLabel(result.getValue()).equals(type))
				.collect(Collectors.toList());
	}

	public List<EvaluationResult> evalDifference(String type, Map<String, alloyParser.ExprContext> quantifiers) {
		List<EvaluationResult> results = eval(type, " - ", quantifiers);
		return results.stream()
				.filter(result -> !CodeUtils.formatLabel(result.getValue()).equals(type))
				.collect(Collectors.toList());
	}

	public List<EvaluationResult> evalIn(String type, Map<String, alloyParser.ExprContext> quantifiers) {
		List<EvaluationResult> results = eval(type, " in ", quantifiers);
		return results.stream()
				.filter(result -> !CodeUtils.formatLabel(result.getValue()).equals(type))
				.collect(Collectors.toList());
	}

	public List<EvaluationResult> evalBinarySetOpByMatchingArity(String expression,
	                                                             String operator,
	                                                             Map<String, alloyParser.ExprContext> quantifiers) {
		if (expression.equals("iden")) {
			return staticSuggestionsPool.fromSignatures().stream()
					.map(suggestion -> new EvaluationResult(suggestion.getLabel(), suggestion.getSortKey()))
					.collect(Collectors.toList());
		}
		try {
			var type = world.parseOneExpressionFromString(expression).type();
			var suggestions = arityMatchingSuggestions.forArityOfType(type, quantifiers);
			return suggestions.stream()
//			                  .filter(suggestion -> !CodeUtils.formatLabel(suggestion.getLabel()).equals(expression))
					.map(suggestion -> new EvaluationResult(suggestion.getLabel(), suggestion.getSortKey()))
					.collect(Collectors.toList());
		} catch (IOException e) {
			logger.error(e.getMessage());
			return List.of();
		}
	}

	public List<EvaluationResult> evalForwardRelationalChainFromSourceExprToDestinationExpr(String expression,
	                                                                                        String leftHandSideExpr,
	                                                                                        Map<String, alloyParser.ExprContext> quantifiers) {
		try {
			var type = world.parseOneExpressionFromString(expression).type();
			var degree = type.arity() == 1 ? SuggestionTerm.Degree.SIG : SuggestionTerm.Degree.RELATION;
			var startingSuggestion = new SuggestionTerm(expression, type, degree);
			var leftHandSideType = world.parseOneExpressionFromString(leftHandSideExpr).type();
			var suggestions = relationalGraphSuggestions.buildForwardSuggestionWithDestinationType(startingSuggestion,
					leftHandSideType,
					quantifiers);
			return suggestions.stream()
					.filter(suggestion -> !CodeUtils.formatLabel(suggestion.getLabel()).equals(expression))
					.map(suggestion -> new EvaluationResult(suggestion.getLabel(), suggestion.getSortKey()))
					.collect(Collectors.toList());
		} catch (IOException e) {
			logger.error(e.getMessage());
			return List.of();
		}
	}

	public List<EvaluationResult> evalRelationalChainForDestinationExpr(String leftHandSideExpr,
	                                                                    String operator,
	                                                                    Map<String, alloyParser.ExprContext> quantifiers) {
		try {
			var type = world.parseOneExpressionFromString(leftHandSideExpr).type();
			var suggestions = relationalGraphSuggestions.buildReverseSuggestions(type, quantifiers);
			return suggestions.stream()
					.filter(suggestion -> !CodeUtils.formatLabel(suggestion.getLabel())
							.equals(leftHandSideExpr))
					.map(suggestion -> new EvaluationResult(suggestion.getLabel(), suggestion.getSortKey()))
					.collect(Collectors.toList());
		} catch (IOException e) {
			logger.error(e.getMessage());
			return List.of();
		}
	}

	public Boolean doesExpressionsMatch(String expression1, String expression2) {
		try {
			Expr expr1 = world.parseOneExpressionFromString(expression1);
			Expr expr2 = world.parseOneExpressionFromString(expression2);
			return expr1.toString().equals(expr2.toString());
		} catch (Exception e) {
			return false;
		}
	}

}
