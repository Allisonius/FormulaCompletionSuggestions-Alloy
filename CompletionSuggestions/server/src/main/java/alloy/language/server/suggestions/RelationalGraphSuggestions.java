package alloy.language.server.suggestions;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.utils.data.SuggestionTerm;
import edu.mit.csail.sdg.ast.Type;
import edu.mit.csail.sdg.parser.CompModule;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class RelationalGraphSuggestions {

	private final CompModule world;
	private final StaticSuggestionsPool staticSuggestionsPool;
	private LinearModelGraph linearModelGraph;
	private final int MAX_DEPTH = 2;

	public RelationalGraphSuggestions(CompModule world) {
		this.world = world;
		this.linearModelGraph = new LinearModelGraph(world);
		this.staticSuggestionsPool = new StaticSuggestionsPool(world);
	}

	public RelationalGraphSuggestions(CompModule world, StaticSuggestionsPool staticSuggestionsPool) {
		this.world = world;
		this.linearModelGraph = new LinearModelGraph(world);
		this.staticSuggestionsPool = staticSuggestionsPool;
	}

	public List<SuggestionTerm> buildForwardSuggestionWithDestinationType(SuggestionTerm startingSuggestion,
	                                                                      Type destinationType,
	                                                                      Map<String, alloyParser.ExprContext> quantifiers) {
		if (linearModelGraph == null) {
			return List.of();
		}
		List<SuggestionTerm> suggestionsFromQuantifiers = CodeUtils.suggestionListFromQuantifiers(quantifiers, world);
		var allSuggestionTerms =
				Stream.concat(suggestionsFromQuantifiers.stream(), staticSuggestionsPool.fromSignatures().stream()).toList();
		List<SuggestionTerm> suggestions = new ArrayList<>();
		for (int i = 0; i <= MAX_DEPTH; i++) {
			var forwardSuggestions =
					linearModelGraph.findForwardChainForDestinationType(startingSuggestion, "", i, destinationType, allSuggestionTerms);
			for (var relationChain : forwardSuggestions) {
				if (relationChain.isEmpty()) {
					continue;
				}
				var plainSuggestionTerm = makeSuggestionsString(relationChain, true);
				suggestions.add(plainSuggestionTerm);
			}
		}
		return suggestions;
	}

	public List<SuggestionTerm> buildReverseSuggestions(Type destinationType,
	                                                    Map<String, alloyParser.ExprContext> quantifiers) {
		if (linearModelGraph == null) {
			return List.of();
		}
		List<SuggestionTerm> resultSuggestions = new ArrayList<>();
		List<SuggestionTerm> suggestionsFromQuantifiers = CodeUtils.suggestionListFromQuantifiers(quantifiers, world);
		var allSuggestionTerms =
				Stream.concat(suggestionsFromQuantifiers.stream(), staticSuggestionsPool.fromSignatures().stream())
						.collect(Collectors.toList());
		for (int i = 0; i <= MAX_DEPTH; i++) {
			for (var suggestion : allSuggestionTerms) {
				var reverseSuggestions = linearModelGraph.findForwardChainForDestinationType(suggestion, "", i, destinationType, allSuggestionTerms);
				for (var relationChain : reverseSuggestions) {
					if (relationChain.isEmpty()) {
						continue;
					}
					var plainSuggestionTerm = makeSuggestionsString(relationChain, false);
					resultSuggestions.add(plainSuggestionTerm);
				}
			}
		}
		return resultSuggestions;
	}

	public List<SuggestionTerm> buildForwardSuggestions(SuggestionTerm initialSuggestion, Map<String, alloyParser.ExprContext> quantifiers, int depth) {
		if (linearModelGraph == null) {
			return List.of();
		}
		var quantifierSuggestions = CodeUtils.suggestionListFromQuantifiers(quantifiers, world);
		var availableSuggestions = Stream.concat(quantifierSuggestions.stream(), staticSuggestionsPool.fromSignatures().stream())
				.collect(Collectors.toList());
		List<SuggestionTerm> resultSuggestions = new ArrayList<>();
		var forwardSuggestions = linearModelGraph.findForwardChain(initialSuggestion, depth, availableSuggestions);
		for (var relationChain : forwardSuggestions) {
			if (relationChain.isEmpty()) {
				continue;
			}
			var plainSuggestionTerm = makeSuggestionsString(relationChain, true);
			resultSuggestions.add(plainSuggestionTerm);
		}
		return resultSuggestions;
	}

	public List<SuggestionTerm> buildForwardSuggestions(SuggestionTerm initialSuggestion,
	                                                    Map<String, alloyParser.ExprContext> quantifiers) {
		if (linearModelGraph == null) {
			return List.of();
		}
		var quantifierSuggestions = CodeUtils.suggestionListFromQuantifiers(quantifiers, world);
		var availableSuggestions = Stream.concat(quantifierSuggestions.stream(), staticSuggestionsPool.fromSignatures().stream())
				.collect(Collectors.toList());
		List<SuggestionTerm> resultSuggestions = new ArrayList<>();
		for (int i = 0; i <= MAX_DEPTH; i++) {
			var forwardSuggestions = linearModelGraph.findForwardChain(initialSuggestion, i, availableSuggestions);
			for (var relationChain : forwardSuggestions) {
				if (relationChain.isEmpty()) {
					continue;
				}
				var plainSuggestionTerm = makeSuggestionsString(relationChain, true);
				resultSuggestions.add(plainSuggestionTerm);
			}
		}
		return resultSuggestions;
	}

	public SuggestionTerm makeSuggestionsString(List<SuggestionTerm> suggestionChain, boolean removeHead) {
		StringBuilder sb = new StringBuilder();
		var minDegree = SuggestionTerm.Degree.EXTENDED_RELATION_3;
		int startIndex = removeHead ? 1 : 0;
		for (int i = startIndex; i < suggestionChain.size(); i++) {
			sb.append(suggestionChain.get(i).getLabel());
			if (i < suggestionChain.size() - 1) {
				sb.append(".");
			}
			if (suggestionChain.get(i).getDegree().ordinal() < minDegree.ordinal()) {
				minDegree = suggestionChain.get(i).getDegree();
			}
		}
		return new SuggestionTerm(sb.toString(), suggestionChain.get(suggestionChain.size() - 1).getType(), minDegree);
	}
}
