package alloy.language.server.v2;

import alloy.language.server.alloyParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;

public record IncompletionContext(
		ParserRuleContext completionTerm,
//		ParserRuleContext completionOperator
		ParseTree completionOperator
) {
}
