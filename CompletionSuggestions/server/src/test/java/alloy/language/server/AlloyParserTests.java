package alloy.language.server;

import parser.ast.nodes.ModelUnit;
import parser.ast.visitor.PrettyStringVisitor;
import parser.util.AlloyUtil;

public class AlloyParserTests {

    // @Test
    void parserTest() {
        String file_name = "usage/classroom_fol.als";
        // Create object that stores parsed in model
        ModelUnit world = new ModelUnit(null, AlloyUtil.compileAlloyModule(file_name));

        // Create object to traverse over AST and print everything - in this case the
        // whole model. You can make your own extension of the PSV to print type
        // information
        PrettyStringVisitor psv = new PrettyStringVisitor();
        String model = psv.visit(world, null);
        System.out.println(model);

        // Loop over each predicate
//        for (Predicate pred : world.getPredDeclList()) {
//            // Get body, once have body, can use visitor patterns to traverse down to
//            // subformulas - the AlloyParser code base has two templates of visitors that
//            // can be extended
//            String pred_text = psv.visit(pred.getBody(), null);
//
//            // Get body, always boolean prim. type but the subformulas that make up the body
//            // can be more specific types. The subformulas are what we will be completing.
//            System.out.println(pred_text);
//            System.out.println(pred.getBody().getBodyExpr().getType());
//
//            // For example, this prints the types of unary expressions encountered one level
//            // into the AST
//            for (Node child : pred.getBody().getBodyExpr().getChildren()) {
//                if (child instanceof UnaryExpr) {
//                    UnaryExpr child_unary = (UnaryExpr) child;
//                    System.out.println(child_unary.getType());
//                    System.out.println(psv.visit(child_unary, null));
//                }
//            }
//        }
    }
}
