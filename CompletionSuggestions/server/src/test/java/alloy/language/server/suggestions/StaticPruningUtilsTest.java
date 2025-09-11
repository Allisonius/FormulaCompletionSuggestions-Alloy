package alloy.language.server.suggestions;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.utils.CodeUtils;
import arepair.generator.CompatUtils;
import arepair.generator.fragment.Fragment;
import arepair.generator.util.Util;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class StaticPruningUtilsTest {

	private static final CompletionModelBuilder classroomModel = ClassroomFolModel.modelBuilder();

	@Test
	public void testBasicPruning() {
		String leftExpr = "A";
		String operator = "in";
		String rightExpr = "B";

		var inheritanceMap = Map.of(
			"B", "A"
		);

		boolean result = StaticPruningUtils.canBePruned(leftExpr, operator, rightExpr, inheritanceMap);
		System.out.println(result);
	}

	@Test
	public void testPruningForModel() {
		String model = classroomModel.build();
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		var types = CompatUtils.populateTypeInfos(world.getAllReachableSigs());

		var studentSig = types.stream()
			.filter(typeInfo -> typeInfo.getName().equals("Student"))
			.findFirst()
			.orElseThrow(() -> new IllegalArgumentException("Student type not found"));

		var personSig = types.stream()
			.filter(typeInfo -> typeInfo.getName().equals("Person"))
			.findFirst()
			.orElseThrow(() -> new IllegalArgumentException("Person type not found"));

		var inheritanceMap = CompatUtils.buildInheritanceHierarchy(world);

		String operator = "+";
		Fragment op = new Fragment(operator);
		var leftExpression = Util.createExprFromType(studentSig);
		var rightExpression = Util.createExprFromType(personSig);
		var result = Util.isStaticPruned(op, leftExpression, 1, rightExpression, 1, inheritanceMap);
		System.out.println(result);
	}
}