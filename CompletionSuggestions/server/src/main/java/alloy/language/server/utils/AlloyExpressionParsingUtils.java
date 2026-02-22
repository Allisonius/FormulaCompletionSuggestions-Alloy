package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.params.EvaluateSuggestions;
import alloy.language.server.visitors.extractors.FunctionArgumentsExtractorVisitor;
import alloy.language.server.visitors.extractors.PredicateParamExtractorVisitor;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import org.antlr.v4.runtime.CommonToken;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.tree.TerminalNodeImpl;
import org.eclipse.lsp4j.CompletionParams;
import org.eclipse.lsp4j.Position;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class AlloyExpressionParsingUtils {

	private static final Logger logger = LoggerFactory.getLogger(AlloyExpressionParsingUtils.class);

	public static alloyParser.ExprContext parseExpWithQuantifier(alloyParser.ExprContext expr,
	                                                             Map<String, alloyParser.ExprContext> quantifierMap) {
		if (expr.qualName() != null && quantifierMap.containsKey(expr.qualName().getText())) {
			return quantifierMap.get(expr.qualName().getText());
		} else {
			var expressionBuilder = new alloyParser.ExprContext((ParserRuleContext) expr.parent, expr.invokingState);
			if (expr.getChildCount() == 0) {
				return expressionBuilder;
			}
			if (expr.getChildCount() > 1) {
				expressionBuilder.addChild(new TerminalNodeImpl(new CommonToken(22, "(")));
			}
			for (int i = 0; i < expr.getChildCount(); i++) {
				var child = expr.getChild(i);
				if (child instanceof alloyParser.ExprContext) {
					var result = parseExpWithQuantifier((alloyParser.ExprContext) child, quantifierMap);
					expressionBuilder.addChild(result);
				} else if (child instanceof alloyParser.DotOpContext) {
					var nextChild = (i + 1 < expr.getChildCount()) ? expr.getChild(i + 1) : null;
					if (nextChild != null && nextChild.getChildCount() > 0) {
						expressionBuilder.addChild((alloyParser.DotOpContext) child);
					}
				}
				else if (child instanceof RuleContext) {
					expressionBuilder.addChild((RuleContext) child);
				} else if (child instanceof TerminalNodeImpl) {
					expressionBuilder.addChild((TerminalNodeImpl) child);
				}
			}
			if (expr.getChildCount() > 1) {
				expressionBuilder.addChild(new TerminalNodeImpl(new CommonToken(23, ")")));
			}
			return expressionBuilder;
		}
	}

	public static Map<String, alloyParser.ExprContext> getQuantifierMapFromAncestors(alloyParser.ExprContext ctx) {
		if (ctx.quant() != null) {
			Map<String, alloyParser.ExprContext> quantifierMap = new HashMap<>();
			for (var child : ctx.children) {
				if (child instanceof alloyParser.DeclContext) {
					var decl = (alloyParser.DeclContext) child;
					var names = decl.name();
					for (var name : names) {
						quantifierMap.put(name.getText(), parseExpWithQuantifier(decl.expr(), quantifierMap));
					}
				}
			}
			return quantifierMap;
		} else if (ctx.getParent() instanceof alloyParser.ExprContext) {
			return getQuantifierMapFromAncestors((alloyParser.ExprContext) ctx.getParent());
		} else if (ctx.getParent() instanceof alloyParser.BlockOrBarContext) {
			return getQuantifierMapFromAncestors((alloyParser.ExprContext) ctx.getParent().getParent());
		}
		return Map.of();
	}

	public static Map<String, alloyParser.ExprContext> getQuantifierMap(alloyParser.ExprContext ctx,
	                                                                    Map<String, alloyParser.ExprContext> existingDeclarations) {
		if (ctx.quant() != null) {
			//			Map<String, alloyParser.ExprContext> quantifierMap = new HashMap<>();
			Map<String, alloyParser.ExprContext> quantifierMap = new ConcurrentHashMap<>(existingDeclarations);
			for (var child : ctx.decl()) {
				var decl = (alloyParser.DeclContext) child;
				var names = decl.name();
				var expr = findDeclarationExpression(decl.expr());
				if (expr == null) continue;
				if (expr.getChild(expr.getChildCount() - 1).getText().equals("")) {
					continue;
				}
				var parsedExpr = parseExpWithQuantifier(expr, quantifierMap);
				for (var name : names) {
					quantifierMap.put(name.getText(), parsedExpr);
				}

			}
			for (int i = 0; i < ctx.getChildCount(); i++) {
				var child = ctx.getChild(i);
				if (child.getText().equals("|")) {
					if (i + 1 < ctx.getChildCount() && ctx.getChild(i + 1) instanceof alloyParser.ExprContext) {
						var nestedQuantifierMap = getQuantifierMap((alloyParser.ExprContext) ctx.getChild(i + 1), quantifierMap);
						quantifierMap.putAll(nestedQuantifierMap);
					}
				}
			}
			return quantifierMap;
		} else if ((ctx.compareOp() != null || ctx.binOp() != null || ctx.arrowOp() != null) &&
				ctx.getChild(0) instanceof alloyParser.ExprContext) {
			return getQuantifierMap(ctx.expr(0), existingDeclarations);
		} else if (ctx.unOp() != null && ctx.expr().size() > 0) {
			return getQuantifierMap(ctx.expr(0), existingDeclarations);
		} else if (isFunctionCall(ctx) && ctx.getParent() instanceof alloyParser.ExprContext) {
			return getQuantifierMap((alloyParser.ExprContext) ctx.getChild(0), existingDeclarations);
		}
		return Map.of();
	}

	private static boolean isFunctionCall(alloyParser.ExprContext ctx) {
		return ctx.getChildCount() >= 4 && ctx.getChild(1).getText().equals("[") &&
				ctx.getChild(ctx.getChildCount() - 1).getText().equals("]");
	}

	/*
	expr
    : const_
    +| qualName
    -| '@' name
    -| 'this'
    +| unOp expr
    +| expr binOp expr
    +| expr arrowOp expr
    -| expr '[' (',' expr)+ ']'
    -| expr ('!' | 'not')? compareOp expr
    -| expr ('=>' | 'implies')? expr 'else' expr
    -| 'let' letDecl (',' letDecl)* blockOrBar
    +| quant decl (',' decl)* blockOrBar
    -| '{' decl (',' decl)* blockOrBar '}'
    -| '(' expr ')'
    -| block
    ;
    ## + means this rule is handled
    ## - means this rule is not handled yet
	# Only binOp = (.) is eligible for extending chain, otherwise break chain
	# take last expr child and
	 */

	public static Map<String, alloyParser.ExprContext> getPredicateParamsMap(alloyParser.ExprContext ctx) {
		var parent = ctx.getParent();
		while (parent != null && !(parent instanceof alloyParser.PredDeclContext)) {
			parent = parent.getParent();
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
				for (var name : decl.name()) {
					parameters.put(name.getText(), decl.expr());
				}
			}
			return parameters;
		}
	}


	public static String findQualifierName(alloyParser.ExprContext expr) {
		//		var predParamsMap = getPredicateParamsMap(expr);
		//		var quantifierMap = getQuantifierMap(expr);
		//		var quantifiers = quantifierMap.isEmpty() ? getQuantifierMapFromAncestors(expr) : quantifierMap;
		//		var finalMap = new ConcurrentHashMap<>(predParamsMap);
		//		finalMap.putAll(quantifiers);
		//		return findQualifierName(expr, finalMap);
		return findQualifierName(expr, Map.of());
	}

	public static String mergeChildren(alloyParser.ExprContext expr,
	                                   Map<String, alloyParser.ExprContext> quantifierMap) {
		if (expr.qualName() != null && quantifierMap.containsKey(expr.qualName().getText())) {
			return quantifierMap.get(expr.qualName().getText()).getText();
		}
		StringBuilder sb = new StringBuilder();
		for (var child : expr.children) {
			if (child instanceof alloyParser.ExprContext) {
				String mergedChild = mergeChildren((alloyParser.ExprContext) child, quantifierMap);
				sb.append(mergedChild);
			} else {
				sb.append(child.getText());
			}
		}
		return sb.toString();
	}

	public static String textFromExpr(ParserRuleContext expr) {
		if (expr.getChildCount() == 0) return "";
		if (expr.getChildCount() == 1) return expr.getText();
		StringBuilder sb = new StringBuilder();
		for (var child : expr.children) {
			if (sb.length() > 0) {
				sb.append(" ");
			}
			if (child instanceof TerminalNodeImpl) {
				sb.append(child.getText());
			} else if (child instanceof ParserRuleContext) {
				sb.append(textFromExpr((ParserRuleContext) child));
			}
		}
		return sb.toString();
	}

	public static String findQualifierName(alloyParser.ExprContext expr,
	                                       Map<String, alloyParser.ExprContext> quantifierMap) {
		if (expr == null) {
			return "";
		}
		if (expr.dotOp() != null) {
			String leftQualifier = findQualifierName(expr.expr(0), quantifierMap);
			String rightQualifier = findQualifierName(expr.expr(1), quantifierMap);
			if (rightQualifier.isEmpty()) {
				return leftQualifier;
			} else {
				if (expr.expr(1).getChild(0).getText().equals("(")) {
					return rightQualifier;
				} else {
					return leftQualifier + "." + rightQualifier;
				}
			}
		}
		if (expr.implicationOp() != null) {
			return findQualifierName(expr.expr(1), quantifierMap);
		}
		if (expr.getChildCount() > 0 && expr.getChild(0).getText().equals("(") &&
				expr.getChild(expr.getChildCount() - 1).getText().equals(")")) {
			return mergeChildren(expr, quantifierMap);
		}
		if (expr.getChildCount() > 0 && expr.getChild(0).getText().equals("(")) {
			return findQualifierName(expr.expr(0), quantifierMap);
		}
		if (expr.getChildCount() > 2 && expr.getChild(1).getText().equals("[")) {
			String leftQualifier = findQualifierName(expr.expr(0), quantifierMap);
			StringBuilder rightQualifier = new StringBuilder();
			for (int i = 2; i < expr.getChildCount() - 1; i++) {
				var child = expr.getChild(i);
				if (child instanceof alloyParser.ExprContext) {
					String childQualifier = findQualifierName((alloyParser.ExprContext) child, quantifierMap);
					if (!childQualifier.isEmpty()) {
						if (rightQualifier.length() > 0) {
							rightQualifier.append(", ");
						}
						rightQualifier.append(childQualifier);
					}
				} else {
					rightQualifier.append(child.getText());
				}
			}
			if (rightQualifier.length() > 0) {
				return leftQualifier + "[" + rightQualifier + "]";
			} else {
				return leftQualifier;
			}
		}
		if (expr.qualName() != null) {
			var quantExpr = parseExpWithQuantifier(expr, quantifierMap);
			if (quantExpr.getChildCount() > 1) {
				return "(" + textFromExpr(quantExpr) + ")";
			} else {
				return textFromExpr(quantExpr);
			}
		}
		if (expr.const_() != null) {
			return expr.const_().getText();
		}
		if (expr.unOp() != null) {
			return findQualifierName(expr.expr(0), quantifierMap);
		}
		if (expr.unExpOp() != null) {
			return expr.unExpOp().getText() + findQualifierName(expr.expr(0), quantifierMap);
		}

		if (expr.binOp() != null) {
			return findQualifierName(expr.expr(1), quantifierMap);
		}
		if (expr.arrowOp() != null) {
			return findQualifierName(expr.expr(0), quantifierMap) + " -> " +
					findQualifierName(expr.expr(1), quantifierMap);
		}
		if (expr.compareOp() != null && expr.expr().size() > 1 && !expr.expr(1).getText().isEmpty()) {
			return findQualifierName(expr.expr(1), quantifierMap);
		}
		if (expr.setOp() != null) {
			if (expr.expr().size() > 1 && expr.expr(1).getText().isEmpty()) {
				return findQualifierName(expr.expr(0), quantifierMap);
			} else {
				return findQualifierName(expr.expr(1), quantifierMap);
			}
		}
		if (expr.quant() != null) {
			var blockOrBar = expr.blockOrBar();

			if (blockOrBar != null && blockOrBar.expr() != null) {
				return findQualifierName(blockOrBar.expr(), quantifierMap);
			} else if (expr.expr().size() > 0) {
				return findQualifierName(expr.expr(0), quantifierMap);
			} else if (expr.decl() != null && expr.decl().size() > 0) {
				var lastDecl = expr.decl(expr.decl().size() - 1);
				return findQualifierName(lastDecl.expr(), quantifierMap);
			}
		}
		return "";
	}

	/**
	 * @param expr Sibling expression of the completion operator
	 * @return Completion term expression
	 */
	public static alloyParser.ExprContext findCompletionTermExpression(alloyParser.ExprContext expr) {
		if (expr == null) {
			return null;
		}
		if (expr.dotOp() != null) {
			return expr;
		}
		if (expr.implicationOp() != null) {
			return findCompletionTermExpression(expr.expr(1));
		}

		if (expr.expr().size() > 1 && expr.getChild(1).getText().equals("++")) {
			return expr.expr(1);
		}

		if (expr.expr().size() > 1 && expr.getChild(1) instanceof TerminalNodeImpl && expr.getChild(1).getText().equals("else")) {
			return findCompletionTermExpression(expr.expr(1));
		}

		if (expr.getChildCount() > 0 && expr.getChild(0).getText().equals("(") &&
				expr.getChild(expr.getChildCount() - 1).getText().equals(")")) {
			return expr;
		}
		if (expr.getChildCount() > 0 && expr.getChild(0).getText().equals("(")) {
			return findCompletionTermExpression(expr.expr(0));
		}
		if (expr.qualName() != null) {
			return expr;
		}
		if (expr.const_() != null) {
			return expr;
		}
		if (expr.unOp() != null) {
			return findCompletionTermExpression(expr.expr(0));
		}
		if (expr.unExpOp() != null) {
			return expr;
		}

		if (expr.getChild(0) instanceof TerminalNodeImpl && !expr.expr().isEmpty()) {
			return findCompletionTermExpression(expr.expr(0));
		}

		if (expr.binOp() != null) {
			return findCompletionTermExpression(expr.expr(1));
		}
		if (expr.arrowOp() != null) {
			return expr;
		}
		if (expr.compareOp() != null && expr.expr().size() > 1 && !expr.expr(1).getText().isEmpty()) {
			return findCompletionTermExpression(expr.expr(1));
		}
		if (expr.setOp() != null) {
			if (expr.expr().size() > 1 && expr.expr(1).getText().isEmpty()) {
				return findCompletionTermExpression(expr.expr(0));
			} else {
				return findCompletionTermExpression(expr.expr(1));
			}
		}
		if (expr.quant() != null) {
			var blockOrBar = expr.blockOrBar();

			if (blockOrBar != null && blockOrBar.expr() != null) {
				return findCompletionTermExpression(blockOrBar.expr());
			} else if (expr.expr().size() > 0) {
				return findCompletionTermExpression(expr.expr(0));
			} else if (expr.decl() != null && expr.decl().size() > 0) {
				var lastDecl = expr.decl(expr.decl().size() - 1);
				return findCompletionTermExpression(lastDecl.expr());
			}
		}
		return expr;
	}

	public static alloyParser.ExprContext findDeepestExpression(alloyParser.ExprContext expr) {
		if (expr == null) {
			return null;
		}
		if (expr.expr().isEmpty()) {
			return expr;
		} else {
			return findDeepestExpression(expr.expr(expr.expr().size() - 1));
		}
	}

	public static Map<String, alloyParser.ExprContext> findDeclaredVariables(alloyParser.ExprContext expr,
	                                                                         Map<String, alloyParser.ExprContext> existingDeclarations) {
		Map<String, alloyParser.ExprContext> declaredVariables = new ConcurrentHashMap<>(existingDeclarations);
		if (expr == null) {
			return declaredVariables;
		}
		if (expr.getParent() instanceof alloyParser.ExprContext) {
			declaredVariables.putAll(
					findDeclaredVariables((alloyParser.ExprContext) expr.getParent(), existingDeclarations));
		}
		if (
				(expr.getParent() instanceof alloyParser.BlockOrBarContext
						|| expr.getParent() instanceof alloyParser.BlockContext
						|| expr.getParent() instanceof alloyParser.DeclContext
				)
						&& expr.getParent().getParent() instanceof alloyParser.ExprContext) {
			declaredVariables.putAll(
					findDeclaredVariables((alloyParser.ExprContext) expr.getParent().getParent(), existingDeclarations));
		}

		if (expr.decl() != null && !expr.decl().isEmpty()) {
			for (var decl : expr.decl()) {
				if (decl.expr().exception != null) { continue;}
				if (decl.expr().getChildCount() == 3 && decl.expr().getChild(2).getChildCount() == 0) continue;
				var declExpr = parseExpWithQuantifier(decl.expr(), declaredVariables);
				for (var name : decl.name()) {
					declaredVariables.put(name.getText(), declExpr);
				}
			}
		}
		if (expr.letDecl() != null && !expr.letDecl().isEmpty()) {
			for (var decl : expr.letDecl()) {
				var declExpr = parseExpWithQuantifier(decl.expr(), declaredVariables);
				declaredVariables.put(decl.name().getText(), declExpr);
			}
		}
		return declaredVariables;
	}

	public static Map<String, alloyParser.ExprContext> extractDeclaredVariables(String documentText,
	                                                                            CompletionParams position,
	                                                                            alloyParser.AlloyModuleContext tree) {
		Map<String, alloyParser.ExprContext> extractedMap = new ConcurrentHashMap<>();
		try {
			Map<String, alloyParser.ExprContext> predicateMap =
					new PredicateParamExtractorVisitor(documentText, position).visit(tree);
			extractedMap.putAll(predicateMap);
			Map<String, alloyParser.ExprContext> functionMap =
					new FunctionArgumentsExtractorVisitor(documentText, position).visit(tree);
			extractedMap.putAll(functionMap);
			Map<String, alloyParser.ExprContext> quantifierMap =
					new QuantifierExtractorVisitor(documentText, position, predicateMap).visit(tree);
			extractedMap.putAll(quantifierMap);
		} catch (Exception e) {
			logger.error("Error while visiting alloy module context", e);
		}
		return extractedMap;
	}

	public static alloyParser.ExprContext findLeftHandSideExpr(alloyParser.ExprContext ctx) {
//		if (ctx.expr().isEmpty()) {
//			return null;
//		}
		if (!(ctx.getParent() instanceof alloyParser.ExprContext)) {
			return null;
		}
		alloyParser.ExprContext parent = (alloyParser.ExprContext) ctx.getParent();
		if (parent.compareOp() != null || parent.setOp() != null) {
			int ctxAsChildIndex = parent.children.indexOf(ctx);
			alloyParser.ExprContext rightMostSiblingBefore = null;
			for (var childExpr : parent.expr()) {
				if (parent.children.indexOf(childExpr) < ctxAsChildIndex) {
					rightMostSiblingBefore = childExpr;
				}
			}
			return rightMostSiblingBefore;
		}
//		if (ctx.unOp()!= null) {
//			return ctx.expr(0);
//		}
//		if (ctx.setOp() != null) {
//			return ctx.expr(0);
//		}
//		else if (ctx.binOp() != null && suitableOperators.contains(ctx.binOp().getText())) {
//			return ctx.expr(0);
//		}
		else if (ctx.getParent() != null && ctx.getParent() instanceof alloyParser.ExprContext) {
			return findLeftHandSideExpr((alloyParser.ExprContext) ctx.getParent());
		}
		return null;
	}

	public static String buildQuantifierPrefix(Map<String, alloyParser.ExprContext> quantifierMap) {
		StringBuilder prefix = new StringBuilder();
		if (quantifierMap.isEmpty()) {
			return "";
		}
		for (var entry : quantifierMap.entrySet()) {
			if (prefix.length() > 0) {
				prefix.append(", ");
			}
			prefix.append("some ").append(entry.getKey()).append(": ").append(textFromExpr(entry.getValue()));
		}
		prefix.append(" | ");
		return prefix.toString();
	}

	public static List<EvaluateSuggestions.ExpressionComponent> extractExpressionComponents(String expression, Set<String> signatures, Set<String> relations, Set<String> variables) {
		String blockedExpression = "{ " + expression + " }";
		var tree = CodeUtils.buildAlloyParser(blockedExpression);
		return extractExpressionComponents(tree.block().expr(0), signatures, relations, variables);
	}

	private static List<EvaluateSuggestions.ExpressionComponent> extractExpressionComponentsWithOperators(
			alloyParser.ExprContext expr, ParserRuleContext operator, Set<String> signatures, Set<String> relations, Set<String> variables) {
		List<EvaluateSuggestions.ExpressionComponent> components = new ArrayList<>();
		if (expr == null || expr.getChildCount() == 0) {
			return components;
		}
		if (operator != null && expr.expr().size() > 1) {
			components.addAll(extractExpressionComponents(expr.expr(0), signatures, relations, variables));
			components.add(new EvaluateSuggestions.ExpressionComponent(operator.getText(), EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR));
			components.addAll(extractExpressionComponents(expr.expr(1), signatures, relations, variables));
		}
		return components;
	}

	public static List<EvaluateSuggestions.ExpressionComponent> extractExpressionComponents(alloyParser.ExprContext expr, Set<String> signatures, Set<String> relations, Set<String> variables) {
		List<EvaluateSuggestions.ExpressionComponent> components = new ArrayList<>();
		if (expr == null || expr.getChildCount() == 0) {
			return components;
		}

		if (expr.qualName() != null) {
			var qualifier = expr.qualName().getText();
			if (variables.contains(qualifier)) {
				components.add(new EvaluateSuggestions.ExpressionComponent(qualifier, EvaluateSuggestions.ExpressionComponent.ComponentType.VARIABLE));
			} else if (relations.contains(qualifier)) {
				components.add(new EvaluateSuggestions.ExpressionComponent(qualifier, EvaluateSuggestions.ExpressionComponent.ComponentType.RELATION));
			} else if (signatures.contains(qualifier)) {
				components.add(new EvaluateSuggestions.ExpressionComponent(qualifier, EvaluateSuggestions.ExpressionComponent.ComponentType.SIGNATURE));
			} else {
				components.add(new EvaluateSuggestions.ExpressionComponent(qualifier, EvaluateSuggestions.ExpressionComponent.ComponentType.OTHER));
			}
		} else if (expr.const_() != null) {
			components.add(new EvaluateSuggestions.ExpressionComponent(expr.const_().getText(), EvaluateSuggestions.ExpressionComponent.ComponentType.CONSTANT));
		} else if (expr.unOp() != null && expr.expr().size() > 0) {
			components.add(new EvaluateSuggestions.ExpressionComponent(expr.unOp().getText(), EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR));
			components.addAll(extractExpressionComponents(expr.expr(0), signatures, relations, variables));
		} else if (expr.unExpOp() != null && expr.expr().size() > 0) {
			components.add(new EvaluateSuggestions.ExpressionComponent(expr.unExpOp().getText(), EvaluateSuggestions.ExpressionComponent.ComponentType.OPERATOR));
			components.addAll(extractExpressionComponents(expr.expr(0), signatures, relations, variables));
		} else if (expr.binOp() != null && expr.expr().size() > 1) {
			components.addAll(extractExpressionComponentsWithOperators(expr, expr.binOp(), signatures, relations, variables));
		} else if (expr.arrowOp() != null && expr.expr().size() > 1) {
			components.addAll(extractExpressionComponentsWithOperators(expr, expr.arrowOp(), signatures, relations, variables));
		} else if (expr.compareOp() != null && expr.expr().size() > 1) {
			components.addAll(extractExpressionComponentsWithOperators(expr, expr.compareOp(), signatures, relations, variables));
		} else if (expr.setOp() != null && expr.expr().size() > 1) {
			components.addAll(extractExpressionComponentsWithOperators(expr, expr.setOp(), signatures, relations, variables));
		} else if (expr.dotOp() != null && expr.expr().size() > 1) {
			components.addAll(extractExpressionComponentsWithOperators(expr, expr.dotOp(), signatures, relations, variables));
		} else if (expr.expr().size() == 1) {
			return extractExpressionComponents(expr.expr(0), signatures, relations, variables);
		}
		return components;
	}

	public static String findLeadingExpression(alloyParser.ExprContext expr) {
		if (expr == null) {
			return "";
		}
		if (expr.dotOp() != null) {
			return expr.getText();
		}
		if (!expr.expr().isEmpty()) {
			return findLeadingExpression(expr.expr(0));
		}
		return expr.getText();
	}

	public static String findLeadingExpression(String expression) {
		try {
			String blockedExpression = "{ " + expression + " }";
			var tree = CodeUtils.buildAlloyParser(blockedExpression);
			var expr = tree.block().expr(0);
			return findLeadingExpression(expr);
		} catch (Exception e) {
			logger.error("Error while parsing expression: " + expression, e);
			return null;
		}
	}

	public static alloyParser.ExprContext buildExprContextFromString(String expression) {
		try {
			String blockedExpression = "{ " + expression + " }";
			var tree = CodeUtils.buildAlloyParser(blockedExpression);
			return tree.block().expr(0);
		} catch (Exception e) {
			logger.error("Error while parsing expression: " + expression, e);
			return null;
		}
	}

	public static alloyParser.ExprContext findDeclarationExpression(alloyParser.ExprContext expr) {
		if (expr == null) {
			return null;
		}
		if (expr.exception != null) {
			return null;
		}
		if (expr.unOp() != null && expr.expr().size() > 0) {
			return findDeclarationExpression(expr.expr(0));
		}
		if (expr.getChildCount() > 0 && expr.getChild(0).getText().equals("(") &&
				expr.getChild(expr.getChildCount() - 1).getText().equals(")")) {
			return expr;
		}
		if (expr.block() != null) {
			if (expr.block().exception != null) {
				return null;
			}
			return expr.block().expr(0);
		}
		return expr;
	}
}
