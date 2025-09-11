package alloy.language.server.visitors;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;

public class CommandVisitor extends AbstractCompletionVisitors {
	public CommandVisitor(String alloyText,
	                       CompletionParams completionParams,
	                       AlloyEvaluation alloyEvaluation) {
		super(alloyText, completionParams, alloyEvaluation);
	}

	@Override
	public List<CompletionItem> visitCmdDecl(alloyParser.CmdDeclContext ctx) {
		if (completionParams.getPosition()
		                    .getLine() == ctx.getStart()
		                                     .getLine() - 1) {
			if (ctx.getStop().getText().equals("run")) {
				var allFunc = alloyEvaluation.getWorld().getAllFunc().makeConstList();
				return allFunc.stream()
				              .map(func -> {
					              var completionItem = new CompletionItem();
					              completionItem.setLabel(func.label);
					              completionItem.setKind(CompletionItemKind.Function);
					              //				              completionItem.setSortText(String.valueOf(func.getDegree().ordinal()));
					              completionItem.setDocumentation("Documentation: Completion Signatures");
					              completionItem.setDetail("Detail: Signature");
					              return completionItem;
				              })
				              .collect(java.util.stream.Collectors.toList());
			}

			if (ctx.getStop().getText().equals("check")) {
				var allAssertions = alloyEvaluation.getWorld().getAllAssertions();
				return allAssertions.stream()
				                    .map(assertion -> {
					                    var completionItem = new CompletionItem();
					                    completionItem.setLabel(assertion.a);
					                    completionItem.setKind(CompletionItemKind.Function);
					                    completionItem.setDocumentation(assertion.b.toString());
					                    completionItem.setDetail("Detail: Assertion");
					                    return completionItem;
				                    })
				                    .collect(java.util.stream.Collectors.toList());
			}
		}
		return super.visitCmdDecl(ctx);
	}
}
