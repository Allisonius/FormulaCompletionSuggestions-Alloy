package alloy.language.server.visitors;

import alloy.language.server.ConfigManager;
import alloy.language.server.alloyParser;
import alloy.language.server.document.AlloyDocumentModel;
import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyInstanceUtils;
import alloy.language.server.utils.CodeUtils;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import alloy.language.server.visitors.completions.AlloyCompletionVisitorDispatcher;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import edu.mit.csail.sdg.parser.CompModule;
import org.eclipse.lsp4j.*;

import java.lang.reflect.InvocationTargetException;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

public abstract class BaseVisitorTest {

	private AlloyEvaluation alloyEvaluation;
	public BaseVisitorTest() {
		ConfigManager configManager = ConfigManager.getInstance();
		configManager.setEnableMultiTermCompletion(true);
	}

	public alloyParser buildParser(String model) {
		return CodeUtils.buildAlloyParser(model);
	}

	public CompletionParams buildCompletionParams(CompletionModelBuilder modelBuilder) {
		TextDocumentIdentifier textDocument = new TextDocumentIdentifier();
		CompletionContext completionContext = new CompletionContext(CompletionTriggerKind.TriggerCharacter, "");
		Position position =
				new Position(modelBuilder.getCompletionLineNumber(), modelBuilder.getCompletionCharacterNumber());
		return new CompletionParams(textDocument, position, completionContext);
	}

	public AlloyEvaluation buildAlloyEvaluation(String model, CompletionParams completionParams) {
		String curatedText = CodeUtils.getAlloyTextWithoutCompletionLine(model, completionParams);
		CompModule world = AlloyInstanceUtils.buildAlloyModel(curatedText);
		var instance = AlloyInstanceUtils.buildInstance(world);
		this.alloyEvaluation = new AlloyEvaluation(world, instance);
		return alloyEvaluation;
	}

	public List<CompletionItem> generateCompletions(CompletionModelBuilder modelBuilder) {
		String model = modelBuilder.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		this.alloyEvaluation =
				new AlloyEvaluation(documentModel.getModel(), documentModel.getDefaultSolution());
		AlloyCompletionVisitorDispatcher visitors = new AlloyCompletionVisitorDispatcher(alloyEvaluation);

		var parser = CodeUtils.buildAlloyParser(model);
		var tree = parser.alloyModule();

		return visitors.visitAndBuildCompletions(model, completionParams, tree);
	}

	public List<CompletionItem> generateCompletionForVisitor(CompletionModelBuilder modelBuilder,
	                                                         Class<? extends AbstractCompletionVisitors> VisitorClass) {
		String model = modelBuilder.build();
		AlloyDocumentModel documentModel = new AlloyDocumentModel("", model);
		CompletionParams completionParams = buildCompletionParams(modelBuilder);
		this.alloyEvaluation = buildAlloyEvaluation(model, completionParams);

		var parser = CodeUtils.buildAlloyParser(model);
		var tree = parser.alloyModule();

		var quantifiers = new QuantifierExtractorVisitor(model, completionParams).visit(tree);

		try {
			var visitor =
					VisitorClass.getConstructor(String.class, CompletionParams.class, AlloyEvaluation.class, Map.class).newInstance(model, completionParams, alloyEvaluation, quantifiers);

			return visitor.visit(tree);
		} catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
			return null;
		}
	}

	public List<CompletionItem> generateCompletions(AlloyDocumentModel documentModel,
	                                                CompletionModelBuilder modelBuilder) {
		String model = modelBuilder.build();
		CompletionParams completionParams = buildCompletionParams(modelBuilder);

		AlloyEvaluation alloyEvaluation =
				new AlloyEvaluation(documentModel.getModel(), documentModel.getDefaultSolution());
		AlloyCompletionVisitorDispatcher visitors = new AlloyCompletionVisitorDispatcher(alloyEvaluation);

		var parser = CodeUtils.buildAlloyParser(model);
		var tree = parser.alloyModule();

		return visitors.visitAndBuildCompletions(model, completionParams, tree);
	}

	public void printCompletionItems(List<CompletionItem> completionItems) {
		System.out.println("Completion Items: ");
		completionItems.stream()
		               .distinct()
		               .sorted(Comparator.comparing(CompletionItem::getSortText))
		               .map(completionItem -> completionItem.getLabel() + " :: " + completionItem.getDetail())
		               .forEach(System.out::println);
	}

	public Boolean doesCompletionItemMatch(CompletionItem item, String expectedLabel, String quantifierPrefix) {
		if (item.getLabel() == null) {
			return false;
		}
		return alloyEvaluation.doesExpressionsMatch(quantifierPrefix + item.getLabel(), quantifierPrefix + expectedLabel);
	}

	public Boolean doesCompletionContainLabel(List<CompletionItem> completionItems, String expectedLabel) {
		return doesCompletionContainLabel(completionItems, expectedLabel, "");
	}

	public Boolean doesCompletionContainLabel(List<CompletionItem> completionItems, String expectedLabel, String quantifierPrefix) {
		return completionItems.stream()
		                      .anyMatch(item -> doesCompletionItemMatch(item, expectedLabel, quantifierPrefix));
	}
}
