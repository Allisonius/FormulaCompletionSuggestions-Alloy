package alloy.language.server.params;

import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.jsonrpc.validation.NonNull;

import java.util.List;

public interface EvaluateSuggestions {
	record EvaluateSuggestionsParams(
			@NonNull
			String documentUri,
			@NonNull
			Position position,
			@NonNull
			String incompleteExpression,
			@NonNull
			String expectedTerm,
			@NonNull
			String remainingText,
			@NonNull
			List<String> suggestions
	) {
	}

	record EvaluateSuggestionsResponse(
			// TODO: Move all results in the backend, like suggestionExists, suggestionInTopN
			List<SuggestionEvaluation> evaluations
	) {
	}

	record SuggestionEvaluation(
			String suggestion,
			Integer rank,
			Boolean doesMatchExactly,
			Boolean doesMatchSyntactically,
			Boolean doesMatchSemantically,
			List<ExpressionComponent> expressionComponents
	) {
	}


	record ExpressionComponent(
			String label,
			String type
	) {
		public enum ComponentType {
			VARIABLE,
			FUNCTION,
			OPERATOR,
			SIGNATURE,
			RELATION,
			CONSTANT,
			OTHER
		}

		public ExpressionComponent(String label, ComponentType type) {
			this(label, type.name());
		}
	}
}
