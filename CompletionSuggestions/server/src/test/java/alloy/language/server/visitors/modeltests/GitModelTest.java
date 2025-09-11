package alloy.language.server.visitors.modeltests;

import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.GitModel;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class GitModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = GitModel.modelBuilder();
	private final AlloyDocumentModel documentModel = new AlloyDocumentModel("", modelBuilder.build());

	@Test
	public void testModelSignatures() {
		String model = modelBuilder.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);
//		System.out.println(documentModel.getModel().getAllSigs());
		assertThat(documentModel.getModel().getAllSigs().isEmpty(), is(false));
		assertThat(documentModel.getModel().getAllSigs().makeCopy(), hasItems(hasToString("this/Commit")));

		var alloyModel = documentModel.getModel();
		System.out.println(alloyModel.getAllSigs().size());
		System.out.println(alloyModel.getAllSigs().makeConstList().stream().mapToInt(sig -> sig.getFields().size()).sum());
		System.out.println(alloyModel.getAllSigs().makeConstList().stream().flatMapToInt(sig -> sig.getFields().makeConstList().stream().mapToInt(field -> field.type().arity())).sum());
	}

	@Test
	public void testDotCompletionInsideMethodDeclaration() {
		modelBuilder.withContent("fact f1 {").withCompletionLine("all o : Object, c : Commit | o -> ").withContent("}");
		var completionItems = generateCompletions(modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("c"))));
	}

	@Test
	public void testDotCompletionInsideMethodDeclaration2() {
		modelBuilder.withContent("fun pointsTo[n : Name, s : State] : Commit {")
		            .withCompletionLine("n.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("refs"))));
	}

	@Test
	public void testDotCompletionInsideMethodDeclaration3() {
		modelBuilder.withContent("fun pointsTo[n : Name, s : State] : Commit {")
		            .withCompletionLine("n.refs.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("s"))));
	}

	@Test
	public void testDotCompletionInsideMethodDeclaration4() {
		modelBuilder.withContent("fun HEAD[s: State] : Commit {").withCompletionLine("pointsTo[Head.").withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("s"))));
	}

	@Test
	public void testWithTemporalStateInPredicateArg() {
		documentModel.documentChanged(modelBuilder.build());
		modelBuilder.withContent("pred add_state_change[s,s' : State] {").withCompletionLine("s !=").withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("s'"))));
	}

	@Test
	public void testWithTemporalStateInQuantifier() {
		modelBuilder.withContent("pred add_test_1_3 {")
		            .withCompletionLine("some s, s': State, f: File | add[s,s',Root]")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		//		assertThat(completionItems, hasItems(hasProperty("label", is("s'"))));
	}

	@Test
	public void testBinaryOperatorWithQuantifiedFormula() {
		modelBuilder.withContent("pred p1[s: State] {")
		            .withCompletionLine("all d : Dir | some ^parent.d &")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
				assertThat(completionItems, hasItems(hasProperty("label", is("index.s"))));
	}

	@Test
	public void testBinaryOperatorWithQuantifiedFormula2() {
		modelBuilder.withContent("pred p1[n: Node, c: Commit] {")
		            .withCompletionLine("some p : Tree | (p -> c) in")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
		assertThat(completionItems, hasItems(hasProperty("label", is("n.parent.belongsTo"))));
	}
}
