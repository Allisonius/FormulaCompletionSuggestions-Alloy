package alloy.language.server.suggestions;

import arepair.generator.CompatUtils;
import arepair.generator.fragment.Expression;
import arepair.generator.fragment.Fragment;
import arepair.generator.util.Util;

import java.util.Map;

public class StaticPruningUtils {

	public static boolean canBePruned(String leftExpr, String operator, String rightExpr, Map<String, String> inheritanceMap) {
		Fragment op = new Fragment(operator);
		var leftExpression = Util.createExprFromType(CompatUtils.createTypeInfo(leftExpr));
		var rightExpression = Util.createExprFromType(CompatUtils.createTypeInfo(rightExpr));
		return canBePruned(op, leftExpression, rightExpression, inheritanceMap);
	}

	public static boolean canBePruned(Fragment operator, Expression leftExpr, Expression rightExpr, Map<String, String> inheritanceMap) {
		if (leftExpr == null || rightExpr == null) {
			return false; // Cannot prune if either expression is null
		}
		return Util.isStaticPruned(operator, leftExpr, 1, rightExpr, 1, inheritanceMap);
	}
}
