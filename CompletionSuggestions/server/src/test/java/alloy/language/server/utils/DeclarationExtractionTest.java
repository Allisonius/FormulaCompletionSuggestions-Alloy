package alloy.language.server.utils;

import alloy.language.server.alloyParser;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

public class DeclarationExtractionTest extends BaseVisitorTest {

	private alloyParser.ExprContext buildExpression(String expr) {
		CompletionModelBuilder modelBuilder = CompletionModelBuilder.modelBuilder();
		String model = modelBuilder.withCompletionLine(expr).buildWithoutCommand();

		alloyParser parser = buildParser(model);
		return parser.expr();
	}

	@Test
	public void testQuantifiedType() {
		var expression = buildExpression("all x: Class | x");
		var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(expression, Map.of());
		System.out.println(declaredVariables);
		assertThat(declaredVariables.containsKey("x"), is(true));
		assertThat(declaredVariables.get("x").getText(), is("Class"));
	}

	// let td = { some ts: T | no ts } | some k: K | no td & k
	@Test
	public void testNestedQuantifiedType() {
		var expr = buildExpression("let td = { some ts: T | no ts } | some k: K | no td & k");
		while(expr.expr() != null && !expr.expr().isEmpty()) {
			expr = expr.expr(expr.expr().size() - 1);
		}
		System.out.println(expr.getText());
		var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(expr, Map.of());
		System.out.println(declaredVariables);
		assertThat(declaredVariables.containsKey("td"), is(true));
		assertThat(declaredVariables.get("td").getText(), is("{somets:T|nots}"));
		assertThat(declaredVariables.containsKey("k"), is(true));
		assertThat(declaredVariables.get("k").getText(), is("K"));
	}

	// let ts = { s1,s2:State | some e:Event | s1->e->s2 in
	@Test
	public void testNestedQuantifiedTypeWithIncompleteExpr() {
		var expr = buildExpression("let ts = { s1,s2:State | some e:Event | s1->e->s2 in trans } | all s:Init.^ts | some i:Init | i in");
		while(expr.expr() != null && !expr.expr().isEmpty()) {
			expr = expr.expr(expr.expr().size() - 1);
		}
		System.out.println(expr.getText());
		var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(expr, Map.of());
		System.out.println(declaredVariables);
		assertThat(declaredVariables.containsKey("ts"), is(true));
		assertThat(declaredVariables.get("ts").getText(), is("({s1,s2:State|somee:Event|s1->e->s2intrans})"));
		assertThat(declaredVariables.containsKey("s"), is(true));
		assertThat(declaredVariables.get("s").getText(), is("(Init.(^({s1,s2:State|somee:Event|s1->e->s2intrans})))"));
		assertThat(declaredVariables.containsKey("i"), is(true));
		assertThat(declaredVariables.get("i").getText(), is("Init"));
	}

	// all c : Course, p : c.projects, disj x,y : (Person <: projects).p | some c.grades[x] and some c.grades[y] implies c.grades[x] in c.grades[y].(prev +
	@Test
	public void testNestedQuantifiedTypeWithIncompleteExpr2() {
		var expr = buildExpression("all c : Course, p : c.projects, disj x,y : (Person <: projects).p | some c.grades[x] and some c.grades[y] implies c.grades[x] in c.grades[y].(prev +");
		while(expr.expr() != null && !expr.expr().isEmpty()) {
			expr = expr.expr(expr.expr().size() - 1);
		}
		System.out.println(expr.getText());
		var declaredVariables = AlloyExpressionParsingUtils.findDeclaredVariables(expr, Map.of());
		System.out.println(declaredVariables);
		assertThat(declaredVariables.containsKey("c"), is(true));
		assertThat(declaredVariables.get("c").getText(), is("Course"));
		assertThat(declaredVariables.containsKey("p"), is(true));
		assertThat(declaredVariables.get("p").getText(), is("(Course.projects)"));
		assertThat(declaredVariables.containsKey("x"), is(true));
		assertThat(declaredVariables.get("x").getText(), is("((((Person<:projects))).(Course.projects))"));
		assertThat(declaredVariables.containsKey("y"), is(true));
		assertThat(declaredVariables.get("y").getText(), is("((((Person<:projects))).(Course.projects))"));
	}
}
