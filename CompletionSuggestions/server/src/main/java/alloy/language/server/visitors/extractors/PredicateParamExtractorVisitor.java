package alloy.language.server.visitors.extractors;

import alloy.language.server.alloyParser;
import org.eclipse.lsp4j.CompletionParams;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class PredicateParamExtractorVisitor extends AbstractExtractorVisitors {
	public PredicateParamExtractorVisitor(String alloyText, CompletionParams completionParams) {
		super(alloyText, completionParams);
	}

	@Override
	public Map<String, alloyParser.ExprContext> visitExpr(alloyParser.ExprContext ctx) {
		if (isCompletionTriggeringLine(ctx)) {
			var parent = ctx.getParent();
			while(parent != null && !(parent instanceof alloyParser.PredDeclContext)) {
				parent = parent.getParent();
			}
			if (parent == null) {
				return Map.of();
			}
			var predDecl = (alloyParser.PredDeclContext) parent;
			if (predDecl == null) {
				return Map.of();
			}
			var paraDecls = predDecl.paraDecls();
			if (paraDecls == null) {
				return Map.of();
			} else {
				Map<String, alloyParser.ExprContext> parameters = new ConcurrentHashMap<>();
				var declarations = paraDecls.decl();
				for (var decl : declarations) {
					for(var name : decl.name()) {
						parameters.put(name.getText(), decl.expr());
					}
				}
				return parameters;
			}
		}
		return super.visitExpr(ctx);
	}
}
