package usage;

import edu.mit.csail.sdg.parser.CompModule;
import parser.ast.nodes.ModelUnit;
import parser.ast.visitor.PrettyStringVisitor;
import parser.util.AlloyUtil;
import parser.util.FileUtil;

public class UsageExample {

  public static void main(String[] args) {
	  //Read in Alloy file
	  String file = "models/dynamic_ball_graph.als";
	  CompModule module = AlloyUtil.compileAlloyModule(file);
      ModelUnit mu = new ModelUnit(null, module);
    
      //This is one visitor pattern over the model, it visits node in the AST and prints it
      //Producing a replica of the Alloy model
      PrettyStringVisitor psv = new PrettyStringVisitor();
      //Writing it to a file here
      FileUtil.writeText(mu.accept(psv,null),"results/dynamic_bal_graph.als",true);
  }
}