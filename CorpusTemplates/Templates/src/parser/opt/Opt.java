package parser.opt;

import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Options.SatSolver;
import parser.ast.visitor.CloneVisitor;
import parser.ast.visitor.PrettyStringVisitor;
import parser.util.AlloyUtil;
import parser.util.FileUtil;

public class Opt {

	/**
	   * Path to the model.
	   */
	  protected String modelPath;
	  /**
	   * Correct model as string.
	   */
	  protected String correctModelAsString;
	  /**
	   * Scope for equivalence check and test generation.
	   */
	  protected int scope;
	  /**
	   * A4Options for solving.
	   */
	  protected A4Options options;
	  /**
	   * Pretty printer
	   */
	  protected PrettyStringVisitor psv;
	  /**
	   * Clone visitor
	   */
	  protected CloneVisitor cv;
	  
	  /**
	   * Path to the directory where mutants are generated.
	   */
	  protected String mutantDirPath;
	  /**
	   * Path to the test suite.
	   */
	  protected String testPath;

	  public Opt(String modelPath, String correctModelPath, int scope, String solverName) {
	    this.modelPath = modelPath;
	    this.correctModelAsString =
	        correctModelPath != null && FileUtil.fileExists(correctModelPath) ? FileUtil
	            .readText(correctModelPath) : "";
	    this.scope = scope;
	    this.options = new A4Options();
	    options.noOverflow = true;
	    //options.solver = getSatSolver(solverName);
	    options.solver = A4Options.SatSolver.MiniSatJNI;
	 //   AlloyUtil.loadMiniSatSolver(options.solver);
	    this.psv = new PrettyStringVisitor();
	    this.cv = new CloneVisitor();
	  }
	  
	  public Opt(String modelPath, String mutantDirPath, String testPath) {
		    this.modelPath = modelPath;
		    this.mutantDirPath = mutantDirPath;
		    this.testPath = testPath;
		    this.options = new A4Options();
		    options.noOverflow = true;
		    options.solver = A4Options.SatSolver.MiniSatJNI;
		   // options.solver = A4Options.SatSolver.SAT4J;
		    //AlloyUtil.loadMiniSatSolver(options.solver);
		    this.psv = new PrettyStringVisitor();
		  }

	  public Opt(String modelPath, String correctModelPath, int scope) {
	    this(modelPath, correctModelPath, scope, null);
	  }

	  public SatSolver getSatSolver(String solverName) {
	    if (solverName == null) {
	      return SatSolver.MiniSatJNI;
	    }
	    switch (solverName) {
	      case "mini-sat-unsat-core": return SatSolver.MiniSatProverJNI;
	      default: return SatSolver.MiniSatJNI;
	    }
	  }

	  public String getModelPath() {
	    return modelPath;
	  }

	  public String getCorrectModelAsString() {
	    return correctModelAsString;
	  }

	  public int getScope() {
	    return scope;
	  }

	  public A4Options getOptions() {
	    return options;
	  }

	  public PrettyStringVisitor getPSV() {
	    return psv;
	  }

	  public CloneVisitor getCV() {
	    return cv;
	  }
	  
	  public String getMutantDirPath() {
		    return mutantDirPath;
	  }
	  
	  public String getTestPath() {
		    return testPath;
	  }
	  
	  public boolean noTest() {
		  return testPath == null;
	  }

}
