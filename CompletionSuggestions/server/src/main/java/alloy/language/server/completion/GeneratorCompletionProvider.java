package alloy.language.server.completion;

import alloy.language.server.alloyParser;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.CodeUtils;
import arepair.generator.CompatUtils;
import arepair.generator.Generator;
import arepair.generator.etc.BoundType;
import arepair.generator.etc.Card;
import arepair.generator.fragment.Type;
import arepair.generator.opt.GeneratorOpt;
import arepair.generator.util.TypeInfo;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static arepair.generator.util.Util.createType;
import static arepair.generator.util.Util.findCardinality;

public class GeneratorCompletionProvider implements CompletionProvider {

    private final AlloyEvaluation alloyEvaluation;
    private final alloyParser.AlloyModuleContext tree;

    public GeneratorCompletionProvider(AlloyEvaluation alloyEvaluation, alloyParser.AlloyModuleContext tree) {
        this.alloyEvaluation = alloyEvaluation;
        this.tree = tree;
    }

    @Override
    public List<CompletionItem> provideCompletions(String documentText, CompletionParams position, Map<String, alloyParser.ExprContext> quantifierMap) {
        var sigs = alloyEvaluation.getWorld().getAllReachableSigs();
        var basicTypes = CompatUtils.populateTypeInfos(sigs);
        var quantifierMapWithType = quantifierMap.entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, entry -> CodeUtils.getTypeOfExpression(entry.getValue(), alloyEvaluation.getWorld())));
        var quantifierTypes = CompatUtils.populateTypeInfos(quantifierMapWithType);

        var allTypes = Stream.concat(basicTypes.stream(), quantifierTypes.stream())
                .toList();
        GeneratorOpt opt = new GeneratorOpt(
                BoundType.DEPTH, 3, 3, 2, 3, false);
        opt.setModuloPruning(false);

        Generator generator = new Generator(opt, alloyEvaluation);
        var results = generator.generateExpressions(opt, allTypes).values().stream().flatMap(integerListMap -> integerListMap.values().stream()).flatMap(Collection::stream).collect(
                Collectors.toSet()).stream().map(CompatUtils::completionItemFromExpression).toList();
        return results;
    }
}
