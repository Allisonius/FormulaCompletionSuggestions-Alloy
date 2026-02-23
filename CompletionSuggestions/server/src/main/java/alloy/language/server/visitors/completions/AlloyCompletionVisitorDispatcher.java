package alloy.language.server.visitors.completions;

import alloy.language.server.ConfigManager;
import alloy.language.server.alloyParser;
import alloy.language.server.completion.CompletionProvider;
import alloy.language.server.completion.GeneratorCompletionProvider;
import alloy.language.server.completion.VisitorRuleProvider;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyExpressionParsingUtils;
import alloy.language.server.v2.CompletionContextExtractorCompletionProvider;
import alloy.language.server.visitors.extractors.FunctionArgumentsExtractorVisitor;
import alloy.language.server.visitors.extractors.PredicateParamExtractorVisitor;
import alloy.language.server.visitors.extractors.QuantifierExtractorVisitor;
import alloy.language.server.visitors.completions.operators.DefaultTermVisitor;
import alloy.language.server.visitors.completions.operators.binary.ArrowExprVisitor;
import alloy.language.server.visitors.completions.operators.set.BinarySetOperatorVisitor;
import alloy.language.server.visitors.completions.operators.set.DifferenceOperatorVisitor;
import alloy.language.server.visitors.completions.operators.set.DotVisitor;
import alloy.language.server.visitors.completions.operators.set.RelationalChainAfterBinaryOperatorVisitor;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class AlloyCompletionVisitorDispatcher {
    private static final Logger logger = LoggerFactory.getLogger(AlloyCompletionVisitorDispatcher.class);

    private final List<AbstractCompletionVisitors> completionVisitors;
    private final AlloyEvaluation alloyEvaluation;

    public AlloyCompletionVisitorDispatcher(AlloyEvaluation alloyEvaluation) {
        this.completionVisitors = new ArrayList<>();
        this.alloyEvaluation = alloyEvaluation;
    }

    public List<CompletionItem> visitAndBuildCompletions(String documentText,
                                                         CompletionParams position,
                                                         alloyParser.AlloyModuleContext tree) {
        Map<String, alloyParser.ExprContext> extractedMap = AlloyExpressionParsingUtils.extractDeclaredVariables(documentText, position, tree);
        if (ConfigManager.getInstance().useLegacyVisitorBasedCompletionProvider()) {
	        CompletionProvider visitorRuleProvider =
			        new VisitorRuleProvider(alloyEvaluation, tree);
	        var completions = visitorRuleProvider.provideCompletions(documentText, position, extractedMap);
	        return completions;
        }
		else if (ConfigManager.getInstance().useGeneratorCompletion()) {
            CompletionProvider generatorCompletionProvider =
                    new GeneratorCompletionProvider(alloyEvaluation, tree);
            var generatorCompletions = generatorCompletionProvider.provideCompletions(documentText, position, extractedMap);
            return generatorCompletions;
        } else {
	        CompletionProvider contextExtractorCompletionProvider =
			        new CompletionContextExtractorCompletionProvider(alloyEvaluation, tree);
	        var completions = contextExtractorCompletionProvider.provideCompletions(documentText, position, extractedMap);
	        return completions;
        }
    }
}
