package alloy.language.server.suggestions;

import alloy.language.server.utils.CodeUtils;
import alloy.language.server.utils.data.SuggestionTerm;
import arepair.generator.CompatUtils;
import arepair.generator.fragment.Fragment;
import arepair.generator.util.Util;
import edu.mit.csail.sdg.ast.Type;
import edu.mit.csail.sdg.parser.CompModule;

import java.util.*;

public class LinearModelGraph {
	private final CompModule world;
	//	private final StaticSuggestions staticSuggestions;
	Map<String, String> inheritanceMap;

	public LinearModelGraph(CompModule world) {
		this.world = world;
		//		this.staticSuggestions = new StaticSuggestions(world);
		this.inheritanceMap = CompatUtils.buildInheritanceHierarchy(world);
	}

	public LinearModelGraph(CompModule world, StaticSuggestionsPool staticSuggestionsPool) {
		this.world = world;
		//		this.staticSuggestions = staticSuggestions;
	}

	public boolean shouldAllowChaining(String leftLabel, String rightLabel) {
		if (leftLabel.equals(rightLabel)) {
			return false;
		}
		if (("~" + leftLabel).equals(rightLabel) || (leftLabel.equals("~" + rightLabel))) {
			return false;
		}
		if (leftLabel.replaceFirst("[*^~]", "").equals(rightLabel.replaceFirst("[*^~]", ""))) {
			return false;
		}
		return true;
	}

	public List<List<SuggestionTerm>> findForwardChain(SuggestionTerm sourceSuggestion,
	                                                   int chainLength,
	                                                   List<SuggestionTerm> availableSuggestions) {
		if (chainLength == 0) {
			return List.of(List.of(sourceSuggestion));
		}
		List<List<SuggestionTerm>> composedChain = new ArrayList<>();
		for (var suggestion : availableSuggestions) {
			if (sourceSuggestion.getType().arity() == 1 && suggestion.getType().arity() == 1) continue;
			if (doesLeftTypeMatchesRightType(sourceSuggestion, suggestion) &&
					shouldAllowChaining(sourceSuggestion.getLabel(), suggestion.getLabel())) {

				if (sourceSuggestion.getExpression() != null && StaticPruningUtils.canBePruned(new Fragment("."), sourceSuggestion.getExpression(),
						suggestion.getExpression(), inheritanceMap)) {
					continue;
				}

				var extendedExpression = Util.buildExpression(
						1, new Fragment("."),
						sourceSuggestion.getExpression(),
						suggestion.getExpression(),
						inheritanceMap
				);
				var oldExpression = suggestion.getExpression();
				suggestion.setExpression(extendedExpression);
				var forwardChains = findForwardChain(suggestion, chainLength - 1, availableSuggestions);
				suggestion.setExpression(oldExpression);
				List<List<SuggestionTerm>> composed = new ArrayList<>();
				for (var fc : forwardChains) {
					List<SuggestionTerm> chain = new ArrayList<>();
					chain.add(sourceSuggestion);
					chain.addAll(1, fc);
					composed.add(chain);
				}
				composedChain.addAll(composed);
			}
		}
		return composedChain;
	}

	public Type getTailOfType(Type type) {
		if (type.arity() == 1) {
			// TODO: 8/21/24 Check cases if for sig
			//			return null;
			return type;
		}
		var tail = type.fold().get(0).subList(1, type.arity());
		Type resultType = tail.get(0).type();
		for (int i = 1; i < tail.size(); i++) {
			resultType = resultType.product(tail.get(i).type());
		}
		return resultType;
	}

	public String extendBuildExpression(String builtExpression, SuggestionTerm suggestion) {
		StringBuilder sb = new StringBuilder();
		if (!builtExpression.isEmpty()) {
			sb.append(builtExpression);
			sb.append(".");
		}

		var suggestionExpr = suggestion.getType().arity() == 1 ? CodeUtils.formatLabel(suggestion.getType()) :
				"(" + CodeUtils.formatLabel(suggestion.getType()) + ")";
		sb.append(suggestionExpr);
		return sb.toString();
	}

	public boolean doesLeftTypeMatchesRightType(SuggestionTerm left, SuggestionTerm right) {
		if (left.getType().arity() == 1 && right.getType().arity() == 1) return false;

		// TODO: 9/23/24 Should we allow chaining with "univ" or "iden" types?
		var typeOfLastItemInLeft = left.getType().fold().get(0);
		var leftType = typeOfLastItemInLeft.get(typeOfLastItemInLeft.size() - 1);

		var rightType = right.getType().fold().get(0).get(0);

		if (leftType.toString().equals("univ") || rightType.toString().equals("univ")) {
			return true;
		}

		if (left.getType().arity() == 1) {
			var parent = leftType;
			while (parent != null && !parent.toString().equals("univ")) {
				if (parent.equals(rightType)) {
					return true;
				}
				parent = parent.parent;
			}
		}

		if (right.getType().arity() == 1) {
			var parent = rightType;
			while (parent != null && !parent.toString().equals("univ")) {
				if (parent.equals(leftType)) {
					return true;
				}
				parent = parent.parent;
			}
		}

		return leftType.equals(rightType);
	}

	public List<List<SuggestionTerm>> findForwardChainForDestinationType(SuggestionTerm sourceSuggestion,
	                                                                     String builtExpression,
	                                                                     int chainLength,
	                                                                     Type destinationType,
	                                                                     List<SuggestionTerm> availableSuggestions) {
		if (chainLength == 0) {
			// Check if the tail type of the source suggestion are the same as the destination type
			// TODO: 8/21/24 if arity is 1, then check cases for sig
			try {
				String finalExpression = extendBuildExpression(builtExpression, sourceSuggestion);
				var finalType = CodeUtils.getTypeOfExpression(finalExpression, world);
				if (finalType != null && finalType.equals(destinationType) ||
						Objects.requireNonNull(finalType).isSubtypeOf(destinationType) ||
						destinationType.isSubtypeOf(finalType)) {
					return List.of(List.of(sourceSuggestion));
				} else {
					return List.of();
				}
			} catch (Exception e) {
				return List.of();
			}
			//			var tailOfSource = getTailOfType(sourceSuggestion.getType());
			//			if (tailOfSource != null && tailOfSource.equals(destinationType)) {
			//				return List.of(List.of(sourceSuggestion));
			//			} else {
			//				return List.of();
			//			}
		}
		List<List<SuggestionTerm>> composedChain = new ArrayList<>();
		for (var suggestion : availableSuggestions) {
			if (sourceSuggestion.getType().arity() == 1 && suggestion.getType().arity() == 1) continue;
			if (doesLeftTypeMatchesRightType(sourceSuggestion, suggestion) &&
					shouldAllowChaining(sourceSuggestion.getLabel(), suggestion.getLabel())) {
				if (sourceSuggestion.getExpression() != null && StaticPruningUtils.canBePruned(new Fragment("."), sourceSuggestion.getExpression(),
						suggestion.getExpression(), inheritanceMap)) {
					continue;
				}
				var extendedExpression = Util.buildExpression(
						1, new Fragment("."),
						sourceSuggestion.getExpression(),
						suggestion.getExpression(),
						inheritanceMap
				);
				var oldExpression = suggestion.getExpression();
				suggestion.setExpression(extendedExpression);
				var forwardChains = findForwardChainForDestinationType(suggestion,
						extendBuildExpression(builtExpression,
								sourceSuggestion),
						chainLength - 1, destinationType,
						availableSuggestions);
				suggestion.setExpression(oldExpression);
				List<List<SuggestionTerm>> composed = new ArrayList<>();
				for (var fc : forwardChains) {
					List<SuggestionTerm> chain = new ArrayList<>();
					chain.add(sourceSuggestion);
					chain.addAll(1, fc);
					composed.add(chain);
				}
				composedChain.addAll(composed);
			}
		}
		return composedChain;
	}
}
