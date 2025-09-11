package alloy.language.server.params;

import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.jsonrpc.validation.NonNull;

public interface SuggestionImpact {
    record SuggestionImpactParams(
            @NonNull
            String documentUri,
            @NonNull
            String incompleteFormula,
            @NonNull
            String suggestion,
            @NonNull
            Position position
    ) {
    }

    record SuggestionImpactResponse(
            String baselineExpression,
            String suggestedExpression,
            Boolean A_iff_B,
            Boolean A_and_B,
            Boolean not_A_and_B,
            Boolean A_and_not_B,
            Boolean not_A_and_not_B
    ) {
    }
}
