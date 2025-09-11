package alloy.language.server.visitors.completions.operators;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;
import org.eclipse.lsp4j.CompletionParams;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DefaultTermVisitor extends AbstractCompletionVisitors {
	public DefaultTermVisitor(String alloyText,
	                          CompletionParams completionParams,
	                          AlloyEvaluation alloyEvaluation,
	                          Map<String, alloyParser.ExprContext> quantifiers) {
		super(alloyText, completionParams, alloyEvaluation, quantifiers);
	}

	@Override
//	public List<CompletionItem> visit(ParseTree tree) {
	public List<CompletionItem> visitExpr(alloyParser.ExprContext ctx) {
		List<CompletionItem> completionItems = new ArrayList<>();
		var idenCompletion = new CompletionItem();
		idenCompletion.setLabel("iden");
		idenCompletion.setKind(CompletionItemKind.Class);
		idenCompletion.setSortText("999");
		idenCompletion.setDocumentation("Documentation: Iden");
		idenCompletion.setDetail("Detail: Iden");

		var noneCompletion = new CompletionItem();
		noneCompletion.setLabel("none");
		noneCompletion.setKind(CompletionItemKind.Class);
		noneCompletion.setSortText("999");
		noneCompletion.setDocumentation("Documentation: None");
		noneCompletion.setDetail("Detail: None");

		var univCompletion = new CompletionItem();
		univCompletion.setLabel("univ");
		univCompletion.setKind(CompletionItemKind.Class);
		univCompletion.setSortText("999");
		univCompletion.setDocumentation("Documentation: Univ");
		univCompletion.setDetail("Detail: Univ");

		completionItems.add(idenCompletion);
		completionItems.add(noneCompletion);
		completionItems.add(univCompletion);

		return completionItems;
	}
}
