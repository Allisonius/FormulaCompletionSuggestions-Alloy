package alloy.language.server.completion;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.visitors.completions.AbstractCompletionVisitors;
import alloy.language.server.visitors.completions.QuantifierCompletionVisitor;
import alloy.language.server.visitors.completions.SigExtVisitor;
import alloy.language.server.visitors.completions.operators.binary.ArrowExprVisitor;
import alloy.language.server.visitors.completions.operators.set.BinarySetOperatorVisitor;
import alloy.language.server.visitors.completions.operators.set.DifferenceOperatorVisitor;
import alloy.language.server.visitors.completions.operators.set.DotVisitor;
import alloy.language.server.visitors.completions.operators.set.RelationalChainAfterBinaryOperatorVisitor;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class VisitorRuleProvider implements CompletionProvider {

    private final List<AbstractCompletionVisitors> completionVisitors;
    private final AlloyEvaluation alloyEvaluation;
    private final alloyParser.AlloyModuleContext tree;

    public VisitorRuleProvider(AlloyEvaluation alloyEvaluation, alloyParser.AlloyModuleContext tree) {
        this.completionVisitors = new ArrayList<>();
        this.alloyEvaluation = alloyEvaluation;
        this.tree = tree;
    }

    private void initiateCompletionVisitors(String documentText,
                                            CompletionParams position,
                                            Map<String, alloyParser.ExprContext> quantifierMap) {
        completionVisitors.clear();
        completionVisitors.add(new SigExtVisitor(documentText, position, alloyEvaluation, quantifierMap));
        completionVisitors.add(new ArrowExprVisitor(documentText, position, alloyEvaluation, quantifierMap));
        completionVisitors.add(new BinarySetOperatorVisitor(documentText, position, alloyEvaluation, quantifierMap));
        completionVisitors.add(new DifferenceOperatorVisitor(documentText, position, alloyEvaluation, quantifierMap));
        completionVisitors.add(new DotVisitor(documentText, position, alloyEvaluation, quantifierMap));
        completionVisitors.add(new QuantifierCompletionVisitor(documentText, position, alloyEvaluation, quantifierMap));
//        completionVisitors.add(new DefaultTermVisitor(documentText, position, alloyEvaluation, quantifierMap));
        completionVisitors.add(
                new RelationalChainAfterBinaryOperatorVisitor(documentText, position, alloyEvaluation,
                        quantifierMap));
    }
    @Override
    public List<CompletionItem> provideCompletions(String documentText, CompletionParams position, Map<String, alloyParser.ExprContext> extractedMap) {
        initiateCompletionVisitors(documentText, position, extractedMap);
        return completionVisitors.parallelStream()
                .flatMap(visitor -> visitor.visit(tree).stream())
                .filter(AbstractCompletionVisitors.distinctByKey(
                        CompletionItem::getLabel))
                .collect(Collectors.toList());
    }
}
