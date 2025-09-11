package arepair.generator;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.ClassroomFolModel;
import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.AlloyInstanceUtils;
import arepair.generator.etc.BoundType;
import arepair.generator.opt.GeneratorOpt;
import arepair.generator.util.TypeAnalyzer;
import arepair.generator.util.TypeInfo;
import edu.mit.csail.sdg.ast.Type;
import edu.mit.csail.sdg.parser.CompModule;
import org.junit.jupiter.api.Test;
import parser.ast.nodes.ModelUnit;

import java.util.*;
import java.util.stream.Collectors;

import static arepair.generator.CompatUtils.populateTypeInfos;

class GeneratorTest {
    @Test
    public void testGenerate() {
        CompletionModelBuilder modelBuilder = ClassroomFolModel.modelBuilder();
        modelBuilder.withContent("pred p1 {")
                .withContent(" all s: Student | no s.Tutors and no s.Teaches")
                .withContent("}");
        CompModule model = AlloyInstanceUtils.buildAlloyModel(modelBuilder.build());
        var instance = AlloyInstanceUtils.buildInstance(model);
        AlloyEvaluation alloyEvaluation = new AlloyEvaluation(model, instance);

        ModelUnit modelUnit = new ModelUnit(null, model);
        TypeAnalyzer typeAnalyzer = new TypeAnalyzer(modelUnit);
        var nodeToExprTypes = typeAnalyzer.getNodeToExprTypes();
        List<TypeInfo> largestValueNode = nodeToExprTypes.values().stream().max(Comparator.comparingInt(List::size))
                .orElseThrow(() -> new RuntimeException("No types found for any node!"));

        System.out.println("Node to Expr Types: " + largestValueNode.stream()
                .map(TypeInfo::toString)
                .collect(Collectors.joining(",\n ")));

        List<TypeInfo> basicTypes = populateTypeInfos(alloyEvaluation.getWorld().getAllReachableSigs());
        Map<String, Type> quantifierMap = new HashMap<>();
        var personType = alloyEvaluation.getWorld().getAllReachableSigs().stream()
                .filter(sig -> sig.label.equals("this/Person"))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("No Person type found!"));
        quantifierMap.put("s", personType.type());

        List<TypeInfo>  quantifierTypes = populateTypeInfos(quantifierMap);

        basicTypes.addAll(quantifierTypes);

        System.out.println("Basic Types: " + basicTypes.stream()
                .map(TypeInfo::toString)
                .collect(Collectors.joining(",\n ")));


        GeneratorOpt opt = new GeneratorOpt(BoundType.DEPTH, 3, 2, 2, 3, false);
        opt.setModuloPruning(false);

        Generator generator = new Generator(opt, alloyEvaluation);
        var results = generator.generateExpressions(opt, basicTypes)
                .values()
                .stream()
                .flatMap(integerListMap -> integerListMap.values().stream())
                .flatMap(Collection::stream)
                .collect(Collectors.toSet());
        System.out.println(results);
    }

}