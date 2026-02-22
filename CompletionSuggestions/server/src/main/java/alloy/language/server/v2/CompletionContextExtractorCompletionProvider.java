package alloy.language.server.v2;

import alloy.language.server.alloyParser;
import alloy.language.server.completion.CompletionProvider;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.utils.data.EvaluationResult;
import org.antlr.v4.runtime.tree.TerminalNodeImpl;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.slf4j.Logger;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Stream;

public class CompletionContextExtractorCompletionProvider implements CompletionProvider {
	private static final Logger logger = org.slf4j.LoggerFactory.getLogger(CompletionContextExtractorCompletionProvider.class);

	private final AlloyEvaluation alloyEvaluation;
	private final alloyParser.AlloyModuleContext tree;

	public CompletionContextExtractorCompletionProvider(AlloyEvaluation alloyEvaluation, alloyParser.AlloyModuleContext tree) {
		this.alloyEvaluation = alloyEvaluation;
		this.tree = tree;
	}


	@Override
	public List<CompletionItem> provideCompletions(String documentText, CompletionParams position, Map<String, alloyParser.ExprContext> quantifierMap) {
		long startTime = System.currentTimeMillis();
		var parser = CodeUtils.buildAlloyParser(documentText);
		CompletionContextExtractorVisitor visitor = new CompletionContextExtractorVisitor(position);
		var context = visitor.visit(parser.alloyModule());

		Map<String, alloyParser.ExprContext> declaredVariables = context.completionTerm() != null ? AlloyExpressionParsingUtils.findDeclaredVariables((alloyParser.ExprContext) context.completionTerm(), quantifierMap) : Map.of();
		var mergedQuantifiers = new ConcurrentHashMap<>(quantifierMap);
		mergedQuantifiers.putAll(declaredVariables);

		List<EvaluationResult> evaluationResults = new ArrayList<>();
		String completionTermQualName = AlloyExpressionParsingUtils.findQualifierName((alloyParser.ExprContext) context.completionTerm(), mergedQuantifiers);
		String operator = context.completionOperator().getText();

		long parseTime = System.currentTimeMillis() - startTime;
		switch (context.completionOperator().getText()) {
			case "." -> {
				evaluationResults = alloyEvaluation.evalDot(completionTermQualName, mergedQuantifiers);

				try {
					var leftHandSideExpr = AlloyExpressionParsingUtils.findLeftHandSideExpr((alloyParser.ExprContext) context.completionTerm());
					String leftHandSideQualifierName = AlloyExpressionParsingUtils.findQualifierName(leftHandSideExpr, mergedQuantifiers);
					var evaluationResults2 =
							alloyEvaluation.evalForwardRelationalChainFromSourceExprToDestinationExpr(completionTermQualName,
									leftHandSideQualifierName,
									mergedQuantifiers);
					evaluationResults.addAll(evaluationResults2);
				} catch (Exception e) {
					logger.error("Error evaluating dot operator: " + e.getMessage());
				}
			}
			case "->" -> {
				var allSigs = alloyEvaluation.getAllSigsAsSuggestions();
				var allQuantifiers = CodeUtils.suggestionListFromQuantifiers(mergedQuantifiers, alloyEvaluation.getWorld());
				evaluationResults = Stream.concat(allSigs.stream(), allQuantifiers.stream())
						.map(s -> new EvaluationResult(s.getLabel(), String.valueOf(s.getDegree().ordinal()))).collect(java.util.stream.Collectors.toList());
			}
			case "extends" -> {
				var allSigs = alloyEvaluation.getAllSigsAsSuggestions();
				evaluationResults = allSigs.stream()
						.map(sig -> new EvaluationResult(sig.getLabel(), String.valueOf(sig.getDegree().ordinal()))).toList();
			}
			case "in" -> {
//				if (context.completionOperator() instanceof TerminalNodeImpl) {
				if (context.completionOperator().getParent() instanceof alloyParser.SigExtContext) {
					var allSigs = alloyEvaluation.getAllSigsAsSuggestions();
					evaluationResults = allSigs.stream()
							.map(sig -> new EvaluationResult(sig.getLabel(), String.valueOf(sig.getDegree().ordinal()))).toList();
				} else {
					var evaluationResults1 = alloyEvaluation.evalBinarySetOpByMatchingArity(completionTermQualName, operator, mergedQuantifiers);

					List<EvaluationResult> evaluationResults2 = new ArrayList<>();
					var leftHandSideQualifierName = completionTermQualName;
					if (operator.equals(".")) {
						String sourceExprQualName = AlloyExpressionParsingUtils.findQualifierName((alloyParser.ExprContext) context.completionTerm(), mergedQuantifiers);
						evaluationResults2 =
								alloyEvaluation.evalForwardRelationalChainFromSourceExprToDestinationExpr(sourceExprQualName,
										leftHandSideQualifierName,
										mergedQuantifiers);
					}
					if (context.completionOperator() != null) {
						evaluationResults2 = alloyEvaluation.evalRelationalChainForDestinationExpr(leftHandSideQualifierName, operator, mergedQuantifiers);
					}
					evaluationResults.addAll(evaluationResults1);
					evaluationResults.addAll(evaluationResults2);
				}
			}
			case "+", "-", "&", "=" -> {
				var evaluationResults1 = alloyEvaluation.evalBinarySetOpByMatchingArity(completionTermQualName, operator, mergedQuantifiers);

				List<EvaluationResult> evaluationResults2 = new ArrayList<>();
				var leftHandSideQualifierName = completionTermQualName;
				if (operator.equals(".")) {
					String sourceExprQualName = AlloyExpressionParsingUtils.findQualifierName((alloyParser.ExprContext) context.completionTerm(), mergedQuantifiers);
					evaluationResults2 =
							alloyEvaluation.evalForwardRelationalChainFromSourceExprToDestinationExpr(sourceExprQualName,
									leftHandSideQualifierName,
									mergedQuantifiers);
				}
				if (context.completionOperator() != null) {
					evaluationResults2 = alloyEvaluation.evalRelationalChainForDestinationExpr(leftHandSideQualifierName, operator, mergedQuantifiers);
				}
				evaluationResults.addAll(evaluationResults1);
				evaluationResults.addAll(evaluationResults2);
			}
		}

		long evaluationTime = System.currentTimeMillis() - startTime - parseTime;
		var completionItems = new ArrayList<>(evaluationResults.stream()
				.map(EvaluationResult::toCompletionItemOfVariableKind)
				.toList());
		var measurementCompletionItem = new CompletionItem("<TIME>");
		/*
		 * detail: parse time
		 * documentation: evaluation time
		 */
		measurementCompletionItem.setDetail(Long.toString(parseTime));
		measurementCompletionItem.setDocumentation(Long.toString(evaluationTime));
		measurementCompletionItem.setSortText("9999999999");
		completionItems.add(measurementCompletionItem);
		return completionItems;
	}
}
