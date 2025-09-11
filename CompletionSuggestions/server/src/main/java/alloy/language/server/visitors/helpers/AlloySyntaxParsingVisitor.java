package alloy.language.server.visitors.helpers;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.ArrayList;
import java.util.List;

public class AlloySyntaxParsingVisitor extends alloyBaseVisitor<String> {
	private List<RuleContext> removableContexts = new ArrayList<>();

	public AlloySyntaxParsingVisitor(List<RuleContext> removableContexts) {
		this.removableContexts = removableContexts;
	}

	private String parseContext(ParseTree ctx) {
		if (removableContexts.stream().anyMatch( rm -> rm.equals(ctx))) {
			return "";
		}

		if (ctx instanceof TerminalNode){
			if( ctx.getText().equals("<EOF>")) {
				return "";
			}
			if (ctx.getText().equals(".")){
				return ctx.getText();
			} else {
				return " " + ctx.getText();
			}
		}

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < ctx.getChildCount(); i++) {
			var child = ctx.getChild(i);
			if (child.getText()
			         .equals("}")) {
				sb.append("\n");
			}
			if (i > 0 && child instanceof alloyParser.ExprContext && ctx.getChild(i - 1) instanceof alloyParser.ExprContext) {
				sb.append("\n");
			}
			sb.append(parseContext(child));
			if (child.getText()
			         .equals("{")) {
				sb.append("\n");
			}
		}
		if (ctx instanceof alloyParser.BlockContext || ctx instanceof alloyParser.ParagraphContext ||
		    ctx instanceof alloyParser.DeclContext) {
			sb.append("\n");
		}
		return sb.toString();
	}

	@Override
	public String visitAlloyModule(alloyParser.AlloyModuleContext ctx) {
		return parseContext(ctx);
	}
}
