package alloy.language.server.suggestions;

import alloy.language.server.utils.CodeUtils;
import alloy.language.server.utils.data.SuggestionTerm;
import arepair.generator.CompatUtils;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.parser.CompModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Suggestion rules:
 * - Take sigs first
 * - Then take fields/relations
 * - Then take the qualified variables
 * - If no suggestions are found:
 * - take quantified variables if exists
 */

/**
 * How to reduce the number of suggestions:
 * - for ., remove the types that are same as the qualifiers
 * -
 */

public class StaticSuggestionsPool {

	private static final Logger log = LoggerFactory.getLogger(StaticSuggestionsPool.class);
	private final CompModule world;
	private final List<SuggestionTerm> suggestionTerms;

	public StaticSuggestionsPool(CompModule world) {
		this.world = world;
		this.suggestionTerms = buildSuggestionTerms();
	}

	private List<SuggestionTerm> buildSuggestionTerms() {
		List<SuggestionTerm> suggestions = new ArrayList<>();
		for (Sig sig : world.getAllReachableSigs()) {
			if (!sig.builtin && !sig.label.startsWith("this/")) {
				continue;
			}
			if (sig.label.equals("seq/Int")) {
				continue;
			}
			suggestions.add(new SuggestionTerm(CodeUtils.formatLabel(sig.label), sig.type(),
					sig.builtin ? SuggestionTerm.Degree.BUILT_IN : SuggestionTerm.Degree.SIG,
					CompatUtils.createExpression(sig)));
			if (!sig.label.equals("univ") && sig.isVariable != null) {
				suggestions.add(new SuggestionTerm(CodeUtils.formatLabel(sig.label) + "'", sig.type(),
						sig.isTopLevel() ? SuggestionTerm.Degree.BUILT_IN :
								SuggestionTerm.Degree.SIG, CompatUtils.createExpression(sig)));
			}
			for (var field : sig.getFields()) {
				var fieldExpression = CompatUtils.createExpression(field);
				suggestions.add(
						new SuggestionTerm(field.label, field.type(), SuggestionTerm.Degree.RELATION, fieldExpression));
				if (field.isVariable != null) {
					suggestions.add(new SuggestionTerm(field.label + "'", field.type(), SuggestionTerm.Degree.RELATION,
							fieldExpression));
				}
				if (field.type().arity() == 2) {
					suggestions.add(new SuggestionTerm("~" + field.label,
							field.type().transpose(),
							SuggestionTerm.Degree.EXTENDED_RELATION_1,
							CompatUtils.buildExpression("~", fieldExpression)));
					var relationTypes = field.type().fold().getFirst();
					if (CodeUtils.doesTypesMatch(relationTypes.get(0), relationTypes.get(1))) {
						suggestions.add(new SuggestionTerm("^" + field.label, field.type(),
								SuggestionTerm.Degree.EXTENDED_RELATION_2,
								CompatUtils.buildExpression("^", fieldExpression)));
						suggestions.add(
								new SuggestionTerm("*" + field.label, field.type(),
										SuggestionTerm.Degree.EXTENDED_RELATION_3,
										CompatUtils.buildExpression("*", fieldExpression)));
					}
				}
			}
		}
		for (var func : world.getAllFunc()) {
			try {
				if (func.isPrivate != null || func.isPred || (func.decls != null && !func.decls.isEmpty())) continue;
				String sanitizedLabel = CodeUtils.formatLabel(func.label);
				var expr = CompatUtils.createExpression(sanitizedLabel, func.returnDecl.type());
				var funcSuggestion = new SuggestionTerm(sanitizedLabel, func.returnDecl.type(),
						SuggestionTerm.Degree.RELATION, expr);
				suggestions.add(funcSuggestion);
				if (func.returnDecl.type().arity() == 2) {
					suggestions.add(new SuggestionTerm("~" + sanitizedLabel, func.returnDecl.type().transpose(),
							SuggestionTerm.Degree.EXTENDED_RELATION_1,
							CompatUtils.buildExpression("~", expr)));
					var relationTypes = func.returnDecl.type().fold().getFirst();
					if (CodeUtils.doesTypesMatch(relationTypes.get(0), relationTypes.get(1))) {
						suggestions.add(new SuggestionTerm("^" + sanitizedLabel, func.returnDecl.type(),
								SuggestionTerm.Degree.EXTENDED_RELATION_2,
								CompatUtils.buildExpression("^", expr)));
						suggestions.add(
								new SuggestionTerm("*" + sanitizedLabel, func.returnDecl.type(),
										SuggestionTerm.Degree.EXTENDED_RELATION_3,
										CompatUtils.buildExpression("*", expr)));
					}
				}
			} catch (Exception e) {
				log.warn(e.getMessage());
			}
		}
		return suggestions;
	}

	public List<SuggestionTerm> fromSignatures() {
		return suggestionTerms;
	}
}
