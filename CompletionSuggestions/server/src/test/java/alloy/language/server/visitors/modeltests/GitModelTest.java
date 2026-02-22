package alloy.language.server.visitors.modeltests;

import alloy.language.server.ConfigManager;
import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.GitModel;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.visitors.BaseVisitorTest;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class GitModelTest extends BaseVisitorTest {
	private final CompletionModelBuilder modelBuilder = GitModel.modelBuilder();
	private final AlloyDocumentModel documentModel = new AlloyDocumentModel("", modelBuilder.build());

	@BeforeAll
	public static void setup() {
		// Ensure that the new completion provider is enabled for testing
		ConfigManager.getInstance().setUseNewCompletionProvider(true);
	}

	@Test
	public void testModelSize() {
		String model = modelBuilder.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);
		var world = AlloyInstanceUtils.buildAlloyModel(model);
		String modelSize = AlloyInstanceUtils.modelSize(world);
		System.out.println("Model Size: " + modelSize);
	}

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

		System.out.println(alloyModel.getAllFunc());
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
		modelBuilder.withContent("fun HEAD[s: State] : Commit {").withCompletionLine("pointsTo[HEAD.").withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		assertThat(completionItems, hasItems(hasProperty("label", is("s"))));
	}

	@Test
	public void testWithTemporalStateInPredicateArg() {
		documentModel.documentChanged(modelBuilder.build());
		modelBuilder.withContent("pred add_state_change[s,ss : State] {").withCompletionLine("s !=").withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		assertThat(completionItems, hasItems(hasProperty("label", is("ss"))));
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
		assertThat(completionItems, hasItems(hasProperty("label", is("n.parent.belongsTo"))));
	}

//	pred isStoredInIntermediateTree_part3[n : Node, c : Commit] {
//		some p : Tree | p -> c in n.
//	}
	@Test
	public void testBinaryOperatorWithQuantifiedFormula3() {
		modelBuilder.withContent("pred isStoredInIntermediateTree_part3[n : Node, c : Commit] {")
		            .withCompletionLine("some p : Tree | p -> c in n.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("parent.belongsTo"))));
	}

//	pred allTreesStored[s : State] {
//		all t : stored.s & Tree | Name.(t.content) in
//	}
	@Test
	public void testBinaryOperatorWithQuantifiedFormula4() {
		modelBuilder.withContent("pred allTreesStored[s : State] {")
		            .withCompletionLine("all t : stored.s & Tree | Name.(t.content) in")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("stored.s"))));
	}

	// some p : Tree | p in c.tree.
	@Test
	public void testBinaryOperatorWithQuantifiedFormula5() {
		modelBuilder.withContent("pred test_pred[n : Node, c : Commit] {")
		            .withCompletionLine("some p : Tree | p in c.tree.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("^children"))));
	}

//	pred headsInRefs[s : State] {
//		heads.s in
//	}
	@Test
	public void testBinaryOperatorWithQuantifiedFormula6() {
		modelBuilder.withContent("pred headsInRefs[s : State] {")
		            .withCompletionLine("heads.s in")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		assertThat(completionItems, hasItems(hasProperty("label", is("refs.s.Commit"))));
	}

	//no t : Tree | t in
	@Test
	public void testBinaryOperatorWithQuantifiedFormula7() {
		modelBuilder.withContent("pred test_pred2 {")
		            .withCompletionLine("no t : Tree | t in")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		assertThat(completionItems, hasItems(hasProperty("label", is("t.^children"))));
	}

//	pred allNodesHaveParents[s : State] {
//		all n : current.s | n.parent in
//	}
	@Test
	public void testBinaryOperatorWithQuantifiedFormula8() {
		modelBuilder.withContent("pred allNodesHaveParents[s : State] {")
		            .withCompletionLine("all n : current.s | n.parent in")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		assertThat(completionItems, hasItems(hasProperty("label", is("current.s"))));
	}

	// sig Dir extends Node {
	//	tbc : Tree ->
	//}
	@Test
	public void testFieldTypeCompletionInSignature() {
		modelBuilder.withContent("sig Dir2 extends Node {")
		            .withCompletionLine("    tbc : Tree -> ")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("State"))));
	}

	//pred noDuplicateNamesInDirectories[s : State] {
	//	all d : current.s, disj x,y : (parent.
	//}
	@Test
	public void testFieldTypeCompletionInQuantifiedExpression() {
		modelBuilder.withContent("pred noDuplicateNamesInDirectories[s : State] {")
		            .withCompletionLine("    all d : current.s, disj x,y : (parent.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("d"))));
	}

	//pred allTreesStored[s : State] {
	//	all t : stored.s & Tree | Name.(t.
	//}
	@Test
	public void testFieldTypeCompletionInQuantifiedExpression2() {
		modelBuilder.withContent("pred allTreesStored[s : State] {")
		            .withCompletionLine("    all t : stored.s & Tree | Name.(t.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("content"))));
	}

	//pred allTreesStored[s : State] {
	//	all t : stored.s & Tree | Name.(t.content) in
	//}
	@Test
	public void testFieldTypeCompletionInQuantifiedExpression3() {
		modelBuilder.withContent("pred allTreesStored[s : State] {")
		            .withCompletionLine("    all t : stored.s & Tree | Name.(t.content) in ")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("stored.s"))));
	}

	//all d : Dir | some ^parent.d & index.s implies d.(tbc.s).content = {n : Name, o : Object | some x : parent.d & (index.
	@Test
	public void testFieldTypeCompletionInQuantifiedExpression4() {
		modelBuilder.withContent("pred test_pred3 {")
		            .withCompletionLine("    all d : Dir | some ^parent.d & index.s implies d.(tbc.s).content = {n : Name, o : Object | some x : parent.d & (index.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("s"))));
	}

	//pred rm_rec_update_current[s, sp : State, n : Node] {
	//	current.sp = current.s - (leaves[s, n] + n)
	//}
//	@Test
//	public void testFieldTypeCompletionInQuantifiedExpression5() {
//		modelBuilder.withContent("pred rm_rec_update_current[s, sp : State, n : Node] {")
//				.withCompletionLine("    current.sp = current.s - (leaves[s, n] + ")
//				.withContent("}");
//		var completionItems = generateCompletions(documentModel, modelBuilder);
//		printCompletionItems(completionItems);
//		assertThat(completionItems, hasItems(hasProperty("label", is("n"))));
//	}

	//some c : Commit-stored.s | refs.sp = refs.s ++ HEAD.
	@Test
	public void testFieldTypeCompletionInQuantifiedExpression6() {
		modelBuilder.withContent("pred test_pred4[s, sp: State] {")
		            .withCompletionLine("    some c : Commit-stored.s | refs.sp = refs.s ++ HEAD.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("s"))));
	}

	//{n : current.s - Root | n in f.*parent.
	@Test
	public void testFieldTypeCompletionInQuantifiedExpression7() {
		modelBuilder.withContent("fun dirsContainingOnly [s : State, f : set File] : set Dir {")
		            .withCompletionLine("    {n : current.s - Root | n in f.*parent.")
		            .withContent("}");
		var completionItems = generateCompletions(documentModel, modelBuilder);
		printCompletionItems(completionItems);
		assertThat(completionItems, hasItems(hasProperty("label", is("samepath"))));
	}
}
