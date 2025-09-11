package alloy.language.server.suggestions;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.utils.data.SuggestionTerm;
import edu.mit.csail.sdg.ast.Expr;
import edu.mit.csail.sdg.ast.Type;
import edu.mit.csail.sdg.parser.CompModule;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ArityMatchingSuggestions {
	private final CompModule world;
	private final StaticSuggestionsPool staticSuggestionsPool;

	public ArityMatchingSuggestions(CompModule world) {
		this.world = world;
		this.staticSuggestionsPool = new StaticSuggestionsPool(world);
	}

	public ArityMatchingSuggestions(CompModule world, StaticSuggestionsPool staticSuggestionsPool) {
		this.world = world;
		this.staticSuggestionsPool = staticSuggestionsPool;
	}

	public List<SuggestionTerm> forArityOfType(Type type, Map<String, alloyParser.ExprContext> quantifiers) {
		int expectedArity = type.arity();
		if (expectedArity == 0) return List.of();
		List<SuggestionTerm> suggestions = new ArrayList<>();
		List<SuggestionTerm> suggestionTerms = Stream.concat(
				staticSuggestionsPool.fromSignatures().stream(),
				CodeUtils.suggestionListFromQuantifiers(quantifiers, world).stream()
		).toList();
		for (SuggestionTerm suggestion : suggestionTerms) {
			if (suggestion.getType() == null) {
				continue;
			}
			if (suggestion.getType().arity() == expectedArity) {
				if (expectedArity == 1) {
					suggestions.add(suggestion);
				} else if (type.equals(suggestion.getType())) {
					suggestions.add(suggestion);
				}
			} else if (suggestion.getType().arity() < expectedArity) {
				var typesOfGivenType = type.fold().get(0);
				Expr prefixTypeOfGivenType = typesOfGivenType.get(0);
				for (int i = 1; i < suggestion.getType().arity(); i++) {
					prefixTypeOfGivenType = prefixTypeOfGivenType.product(typesOfGivenType.get(i));
				}
				if (prefixTypeOfGivenType.type().equals(suggestion.getType())) {
					Expr suffixOfGivenType = typesOfGivenType.get(suggestion.getType().arity());
					for (int i = suggestion.getType().arity() + 1; i < typesOfGivenType.size(); i++) {
						suffixOfGivenType = suffixOfGivenType.product(typesOfGivenType.get(i));
					}
					if (suffixOfGivenType == null) continue;
					List<SuggestionTerm> subSuggestions = forArityOfType(suffixOfGivenType.type(), quantifiers);
					for (SuggestionTerm subSuggestion : subSuggestions) {
//						String label = suggestion.getLabel() + " -> " + subSuggestion.getLabel();
						String label = CodeUtils.formatLabel(suggestion.getLabel()) + " -> " + CodeUtils.formatLabel(subSuggestion.getLabel());
						Type suggestionType = CodeUtils.getType(world, label);
						if (type.equals(suggestionType)) {
							suggestions.add(new SuggestionTerm(label, suggestionType, SuggestionTerm.Degree.RELATION));
						}
					}
				}
			}
		}
		return suggestions;
	}
}
