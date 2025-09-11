package parser.ast.visitor;

import static parser.etc.Names.COMMA;
import static parser.etc.Names.DOLLAR;
import static parser.etc.Names.NEW_LINE;
import static parser.etc.Names.UNDERSCORE;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import parser.ast.nodes.Assertion;
import parser.ast.nodes.BinaryExpr;
import parser.ast.nodes.BinaryExpr.BinaryOp;
import parser.ast.nodes.BinaryFormula;
import parser.ast.nodes.Body;
import parser.ast.nodes.CallExpr;
import parser.ast.nodes.CallFormula;
import parser.ast.nodes.Check;
import parser.ast.nodes.ConstExpr;
import parser.ast.nodes.ExprOrFormula;
import parser.ast.nodes.Fact;
import parser.ast.nodes.FieldDecl;
import parser.ast.nodes.FieldExpr;
import parser.ast.nodes.Function;
import parser.ast.nodes.ITEExpr;
import parser.ast.nodes.ITEFormula;
import parser.ast.nodes.LetExpr;
import parser.ast.nodes.ListExpr;
import parser.ast.nodes.ListFormula;
import parser.ast.nodes.ModelUnit;
import parser.ast.nodes.ModuleDecl;
import parser.ast.nodes.Node;
import parser.ast.nodes.OpenDecl;
import parser.ast.nodes.ParamDecl;
import parser.ast.nodes.Predicate;
import parser.ast.nodes.QtExpr;
import parser.ast.nodes.QtFormula;
import parser.ast.nodes.RelDecl;
import parser.ast.nodes.Run;
import parser.ast.nodes.SigDecl;
import parser.ast.nodes.SigExpr;
import parser.ast.nodes.UnaryExpr;
import parser.ast.nodes.UnaryFormula;
import parser.ast.nodes.VarDecl;
import parser.ast.nodes.VarExpr;

public class TemplatesHighVisitor_NoRecursive implements GenericVisitor<String, Object> {

  protected boolean inSigDecl;
  protected boolean inSigFact;
  protected Formatting formatting;
  protected Map<Node, String> nodeStringMap;
  
  //binary set templates
  public HashMap<String, Integer> join_templates;
  public HashMap<String, Integer> intersect_templates;
  public HashMap<String, Integer> difference_templates;
  public HashMap<String, Integer> union_templates;
  public HashMap<String, Integer> arrow_templates;
  public HashMap<String, Integer> math_set_templates;
  public HashMap<String, Integer> domain_templates;
  public HashMap<String, Integer> range_templates;
  
  //binary formula templates
  public HashMap<String, Integer> and_templates;
  public HashMap<String, Integer> or_templates;
  public HashMap<String, Integer> implies_templates;
  public HashMap<String, Integer> biconditional_templates;
  public HashMap<String, Integer> equals_templates;
  public HashMap<String, Integer> not_equals_templates;
  public HashMap<String, Integer> in_templates;
  public HashMap<String, Integer> not_in_templates;
  public HashMap<String, Integer> math_formula_templates;
  
  //unary set templates
  public HashMap<String, Integer> set_card_templates;
  public HashMap<String, Integer> closure_templates;
  public HashMap<String, Integer> rclosure_templates;
  public HashMap<String, Integer> transpose_templates;
  public HashMap<String, Integer> prime_templates;
  
  //unary formula templates
  public HashMap<String, Integer> not_templates;
  public HashMap<String, Integer> set_templates;
  public HashMap<String, Integer> some_templates;
  public HashMap<String, Integer> lone_templates;
  public HashMap<String, Integer> one_templates;
  public HashMap<String, Integer> no_templates;
  
  //quantifier templates
  public HashMap<String, Integer> quant_all_templates;
  public HashMap<String, Integer> quant_some_templates;
  public HashMap<String, Integer> quant_lone_templates;
  public HashMap<String, Integer> quant_one_templates;
  public HashMap<String, Integer> quant_no_templates;
  
  //other templates
  public HashMap<String, Integer> if_else_templates;
  public HashMap<String, Integer> let_templates;
  
  boolean inVar;

  public TemplatesHighVisitor_NoRecursive() {
	  
	inVar= true;
	  
    this.inSigDecl = false;
    this.inSigFact = false;
    this.formatting = new Formatting(true);
    this.nodeStringMap = new LinkedHashMap<>();
    
    this.join_templates = new HashMap<String, Integer>();
    this.intersect_templates = new HashMap<String, Integer>();
    this.difference_templates = new HashMap<String, Integer>();
    this.union_templates = new HashMap<String, Integer>();
    this.arrow_templates = new HashMap<String, Integer>();
    this.math_set_templates = new HashMap<String, Integer>();
    this.domain_templates = new HashMap<String, Integer>();
    this.range_templates = new HashMap<String, Integer>();
    
    this.and_templates = new HashMap<String, Integer>();
    this.or_templates = new HashMap<String, Integer>();
    this.implies_templates = new HashMap<String, Integer>();
    this.biconditional_templates = new HashMap<String, Integer>();
    this.equals_templates = new HashMap<String, Integer>();
    this.not_equals_templates = new HashMap<String, Integer>();
    this.in_templates = new HashMap<String, Integer>();
    this.not_in_templates = new HashMap<String, Integer>();
    this.math_formula_templates = new HashMap<String, Integer>();
    
    this.set_card_templates = new HashMap<String, Integer>();
    this.closure_templates = new HashMap<String, Integer>();
    this.rclosure_templates = new HashMap<String, Integer>();
    this.transpose_templates = new HashMap<String, Integer>();
    this.prime_templates = new HashMap<String, Integer>();
    
    this.not_templates = new HashMap<String, Integer>();
    this.set_templates = new HashMap<String, Integer>();
    this.some_templates = new HashMap<String, Integer>();
    this.lone_templates = new HashMap<String, Integer>();
    this.one_templates = new HashMap<String, Integer>();
    this.no_templates = new HashMap<String, Integer>();
    
    this.quant_all_templates = new HashMap<String, Integer>();
    this.quant_some_templates = new HashMap<String, Integer>();
    this.quant_lone_templates = new HashMap<String, Integer>();
    this.quant_one_templates = new HashMap<String, Integer>();
    this.quant_no_templates = new HashMap<String, Integer>();
    
    this.if_else_templates = new HashMap<String, Integer>();
    this.let_templates = new HashMap<String, Integer>();
  }

  protected String putInMap(Node n, String res) {
    nodeStringMap.put(n, res);
    return res;
  }

  public Map<Node, String> getNodeStringMap() {
    return nodeStringMap;
  }

  @Override
  public String visit(ModelUnit n, Object arg) {
    String moduleDecl = n.getModuleDecl().accept(this, arg);
    String openDecls = String.join(NEW_LINE,
        n.getOpenDeclList().stream().map(openDecl -> openDecl.accept(this, arg))
            .collect(Collectors.toList()));
    String sigDecls = String.join(NEW_LINE,
        n.getSigDeclList().stream().map(signature -> signature.accept(this, arg))
            .collect(Collectors.toList()));
    String predDecls = String.join(NEW_LINE,
        n.getPredDeclList().stream().map(predicate -> predicate.accept(this, arg))
            .collect(Collectors.toList()));
    String funDecls = String.join(NEW_LINE,
        n.getFunDeclList().stream().map(function -> function.accept(this, arg))
            .collect(Collectors.toList()));
    String factDecls = String.join(NEW_LINE,
        n.getFactDeclList().stream().map(fact -> fact.accept(this, arg))
            .collect(Collectors.toList()));
    String assertDecls = String.join(NEW_LINE,
        n.getAssertDeclList().stream().map(assertion -> assertion.accept(this, arg))
            .collect(Collectors.toList()));
    String runCmds = String.join(NEW_LINE,
        n.getRunCmdList().stream().map(run -> run.accept(this, arg)).collect(Collectors.toList()));
    String checkCmds = String.join(NEW_LINE,
        n.getCheckCmdList().stream().map(check -> check.accept(this, arg))
            .collect(Collectors.toList()));
    return putInMap(n, String.join(NEW_LINE,
        Arrays.<CharSequence>asList(moduleDecl, openDecls, sigDecls, predDecls, funDecls, factDecls,
            assertDecls, runCmds, checkCmds)));
  }

  @Override
  public String visit(ModuleDecl n, Object arg) {
    return putInMap(n, String.join(" ", Arrays.<CharSequence>asList("module", n.getModelName())));
  }

  @Override
  public String visit(OpenDecl n, Object arg) {
    return putInMap(n, String.join(" ",
        Arrays.asList("open", n.getFileName(), n.getArguments().toString(), "as", n.getAlias().replaceAll("\\" + DOLLAR, UNDERSCORE))));
  }

  @Override
  public String visit(SigDecl n, Object arg) {
    inSigDecl = true;
    String sigDeclAsString =
    		(n.isVariable() ? "var " : "") + (n.isAbstract() ? "abstract " : "") + n.getMult() + "sig " + n.getName() + " " + (
            n.isTopLevel() ? "" : (n.isSubsig() ? "extends" : "in") + " " + n.getParentName() + " ")
            + "{" +
            (n.getFieldList().size() > 0 ? NEW_LINE + String.join(COMMA + NEW_LINE,
                n.getFieldList().stream().map(field -> field.accept(this, arg))
                    .collect(Collectors.toList())) + NEW_LINE : "") +
            "}";
    inSigDecl = false;
    inSigFact = true;
    sigDeclAsString += (n.hasSigFact() ? "{" + NEW_LINE + n.getSigFact().accept(this, arg)
        + NEW_LINE + "}" : "");
    inSigFact = false;
    return putInMap(n, sigDeclAsString);
  }

  @Override
  public String visit(FieldDecl n, Object arg) {
    return visitRelDecl(n, arg);
  }

  @Override
  public String visit(ParamDecl n, Object arg) {
    return visitRelDecl(n, arg);
  }

  @Override
  public String visit(VarDecl n, Object arg) {
    return visitRelDecl(n, arg);
  }

  private String visitRelDecl(RelDecl n, Object arg) {
    return putInMap(n,
    		(n.isVariable() ? "var " : "") + (n.isDisjoint() ? "disj " : "") + String.join(COMMA,
            n.getVariables().stream().map(variable -> variable.accept(this, arg)).collect(
                Collectors.toList())) + ": " + n.getExpr().accept(this, arg));
  }

  @Override
  public String visit(ExprOrFormula n, Object arg) {
    return n.accept(this, arg);
  }

  @Override
  public String visit(SigExpr n, Object arg) {
	  return "name";
    //return putInMap(n, n.getName());
  }

  @Override
  public String visit(FieldExpr n, Object arg) {
    String name = n.getName();
    if (inSigFact) { // We print "field" with "@field" and also print keywords like "this".
      name = "@" + name;
    }
    return "name";
    //return putInMap(n, name);
  }

  @Override
  public String visit(VarExpr n, Object arg) {
    //return putInMap(n, n.getName());
    return "name";
  }

  @Override
  public String visit(UnaryExpr n, Object arg) {

    String subAsString = n.getSub().accept(this, arg);

    String res =  n.getOp() + subAsString;
    if(!(n.getParent() instanceof UnaryExpr || n.getParent() instanceof BinaryExpr)) {
	    if(n.getOp() == UnaryExpr.UnaryOp.CARDINALITY) {
		    if(!set_card_templates.containsKey(res)) {
		    	set_card_templates.put(res, 0);
		    }
		    set_card_templates.put(res, set_card_templates.get(res) + 1);
	    }
	    else if(n.getOp() == UnaryExpr.UnaryOp.CLOSURE) {
		    if(!closure_templates.containsKey(res)) {
		    	closure_templates.put(res, 0);
		    }
		    closure_templates.put(res, closure_templates.get(res) + 1);
	    }
	    else if(n.getOp() == UnaryExpr.UnaryOp.RCLOSURE) {
		    if(!rclosure_templates.containsKey(res)) {
		    	rclosure_templates.put(res, 0);
		    }
		    rclosure_templates.put(res, rclosure_templates.get(res) + 1);
	    }
	    else if(n.getOp() == UnaryExpr.UnaryOp.TRANSPOSE) {
		    if(!transpose_templates.containsKey(res)) {
		    	transpose_templates.put(res, 0);
		    }
		    transpose_templates.put(res, transpose_templates.get(res) + 1);
	    }
	    else if(n.getOp() == UnaryExpr.UnaryOp.PRIME) {
	    	res = subAsString + n.getOp();
		    if(!prime_templates.containsKey(res)) {
		    	prime_templates.put(res, 0);
		    }
		    prime_templates.put(res, prime_templates.get(res) + 1);
	    }
    }
    
    /*if (n.getOp() == UnaryExpr.UnaryOp.NOOP) {
      return putInMap(n, subAsString);
    }
    else */ if (n.getOp() == UnaryExpr.UnaryOp.PRIME)
    	return putInMap(n, "(" + subAsString + n.getOp() + ")");
    return putInMap(n, "(" + n.getOp() + subAsString + ")");
  }

  @Override
  public String visit(UnaryFormula n, Object arg) {
	  String res = "(" + n.getOp() + n.getSub().accept(this, arg) + ")";
	  
	  if(inVar) {
		  if(n.getOp() == UnaryFormula.UnaryOp.LONE) {
			    if(!lone_templates.containsKey(res)) {
			    	lone_templates.put(res, 0);
			    }
			    lone_templates.put(res, lone_templates.get(res) + 1);
		   }
		  else if(n.getOp() == UnaryFormula.UnaryOp.NO) {
			    if(!no_templates.containsKey(res)) {
			    	no_templates.put(res, 0);
			    }
			    no_templates.put(res, no_templates.get(res) + 1);
		   }
		  else if(n.getOp() == UnaryFormula.UnaryOp.NOT) {
			    if(!not_templates.containsKey(res)) {
			    	not_templates.put(res, 0);
			    }
			    not_templates.put(res, not_templates.get(res) + 1);
		   }
		  else if(n.getOp() == UnaryFormula.UnaryOp.ONE) {
			    if(!one_templates.containsKey(res)) {
			    	one_templates.put(res, 0);
			    }
			    one_templates.put(res, one_templates.get(res) + 1);
		   }
		  else if(n.getOp() == UnaryFormula.UnaryOp.SOME) {
			    if(!some_templates.containsKey(res)) {
			    	some_templates.put(res, 0);
			    }
			    some_templates.put(res, some_templates.get(res) + 1);
		   }
  	}

    return putInMap(n, res);
  }

  @Override
  public String visit(BinaryExpr n, Object arg) {

    if (inSigDecl) {
      if (n.getLeft() instanceof VarExpr) {
        String value = ((VarExpr) n.getLeft()).getName();
        if (value.equals("this")) {
          // E.g.
          // sig Book {
          //	entry: set Name,
          //	listed: entry ->set Listing
          // }
          // entry -> set Listing is actually this.entry -> set Listing.
          putInMap(n.getLeft(), value);
          return putInMap(n, n.getRight().accept(this, arg));
        }
      }
    }
    String leftOpString = n.getLeft().accept(this, arg);
    String rightOpString = n.getRight().accept(this, arg);
    String res = leftOpString + n.getOp() + rightOpString;
    // We replace arithmetic plus and minus with function calls.
    if (n.getOp() == BinaryOp.IPLUS) {
      res = "plus[" + leftOpString + ", " + rightOpString + "]";
    }
    if (n.getOp() == BinaryOp.IMINUS) {
      res = "minus[" + leftOpString + ", " + rightOpString + "]";
    }

    if(!(n.getParent() instanceof UnaryExpr || n.getParent() instanceof BinaryExpr)) {

	    if(n.getOp() == BinaryOp.JOIN) {
		    if(!join_templates.containsKey(res)) {
		    	join_templates.put(res, 0);
		    }
		    join_templates.put(res, join_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.INTERSECT) {
		    if(!intersect_templates.containsKey(res)) {
		    	intersect_templates.put(res, 0);
		    }
		    intersect_templates.put(res, intersect_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.MINUS) {
		    if(!difference_templates.containsKey(res)) {
		    	difference_templates.put(res, 0);
		    }
		    difference_templates.put(res, difference_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.PLUS) {
		    if(!union_templates.containsKey(res)) {
		    	union_templates.put(res, 0);
		    }
		    union_templates.put(res, union_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.ARROW) {
		    if(!arrow_templates.containsKey(res)) {
		    	arrow_templates.put(res, 0);
		    }
		    arrow_templates.put(res, arrow_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.DOMAIN) {
		    if(!domain_templates.containsKey(res)) {
		    	domain_templates.put(res, 0);
		    }
		    domain_templates.put(res, domain_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.RANGE) {
		    if(!range_templates.containsKey(res)) {
		    	range_templates.put(res, 0);
		    }
		    range_templates.put(res, range_templates.get(res) + 1);
	    }
	    else if(n.getOp() == BinaryOp.IMINUS || n.getOp() == BinaryOp.IPLUS || n.getOp() == BinaryOp.REM ||
	    		n.getOp() == BinaryOp.DIV ) {
		    if(!math_set_templates.containsKey(res)) {
		    	math_set_templates.put(res, 0);
		    }
		    math_set_templates.put(res, math_set_templates.get(res) + 1);
	    }
    }

    return putInMap(n, "(" + res + ")");
  }

  @Override
  public String visit(BinaryFormula n, Object arg) {
	  
	  String res = "(" + n.getLeft().accept(this, arg) + n.getOp() + n.getRight().accept(this, arg) + ")";
	  
	  if(inVar) {
		  if(n.getOp() == BinaryFormula.BinaryOp.EQUALS) {
			    if(!equals_templates.containsKey(res)) {
			    	equals_templates.put(res, 0);
			    }
			    equals_templates.put(res, equals_templates.get(res) + 1);
		  }
		  else if(n.getOp() == BinaryFormula.BinaryOp.IFF) {
			    if(!biconditional_templates.containsKey(res)) {
			    	biconditional_templates.put(res, 0);
			    }
			    biconditional_templates.put(res, biconditional_templates.get(res) + 1);
		  }
		  else if(n.getOp() == BinaryFormula.BinaryOp.IMPLIES) {
			    if(!implies_templates.containsKey(res)) {
			    	implies_templates.put(res, 0);
			    }
			    implies_templates.put(res, implies_templates.get(res) + 1);
		  }
		  else if(n.getOp() == BinaryFormula.BinaryOp.IN) {
			    if(!in_templates.containsKey(res)) {
			    	in_templates.put(res, 0);
			    }
			    in_templates.put(res, in_templates.get(res) + 1);
		  }
		  else if(n.getOp() == BinaryFormula.BinaryOp.NOT_EQUALS) {
			    if(!not_equals_templates.containsKey(res)) {
			    	not_equals_templates.put(res, 0);
			    }
			    not_equals_templates.put(res, not_equals_templates.get(res) + 1);
		  }
		  else if(n.getOp() == BinaryFormula.BinaryOp.NOT_IN) {
			    if(!not_in_templates.containsKey(res)) {
			    	not_in_templates.put(res, 0);
			    }
			    not_in_templates.put(res, not_in_templates.get(res) + 1);
		  }
		  else {
			    if(!math_formula_templates.containsKey(res)) {
			    	math_formula_templates.put(res, 0);
			    }
			    math_formula_templates.put(res, math_formula_templates.get(res) + 1);
		  }
	  }
	  
    return putInMap(n,
       res);
  }

  @Override
  public String visit(ListExpr n, Object arg) {
    return putInMap(n, n.getOp().getLabel() + "[" + String.join(COMMA,
        n.getArguments().stream().map(expr -> expr.accept(this, arg))
            .collect(Collectors.toList())) + "]");
  }

  @Override
  public String visit(ListFormula n, Object arg) {
    boolean flattenList = false;
    if (n.getParent() instanceof ListFormula) {
      ListFormula parent = (ListFormula) n.getParent();
      if (parent.getOp() == n.getOp()) {
        flattenList = true;
      }
    }
    
    
    
    String innerString = String.join(n.getOp().toString(),
        n.getArguments().stream().map(expr -> expr.accept(this, arg)).collect(Collectors.toList()));
    
    String res = innerString;
    if(inVar) {
	    if(n.getOp() == ListFormula.ListOp.AND) {
		    if(!and_templates.containsKey(res)) {
		    	and_templates.put(res, 0);
		    }
		    and_templates.put(res, and_templates.get(res) + 1);
	    }
	    else {
		    if(!or_templates.containsKey(res)) {
		    	or_templates.put(res, 0);
		    }
		    or_templates.put(res, or_templates.get(res) + 1);
	    }
    }
    
    if (flattenList) {
      return putInMap(n, innerString);
    }
    return putInMap(n, "(" + innerString + ")");
  }

  @Override
  public String visit(CallExpr n, Object arg) {
	 if(n.getName().contains("ordering")) {
		  return putInMap(n, "(" + n.getName() + "[" + String.join(COMMA,
			        n.getArguments().stream().map(argument -> argument.accept(this, arg))
			            .collect(Collectors.toList())) + "]" + ")");/**/
	 }
	 else {
		 return "fun_call[]";
	 }
	//  return "fun_call[]";
  }

  @Override
  public String visit(CallFormula n, Object arg) {
	 // return "pred_call[]";
	  
	 if(n.getName().contains("ordering")) {
		  return putInMap(n, "(" + n.getName() + "[" + String.join(COMMA,
			        n.getArguments().stream().map(argument -> argument.accept(this, arg))
			            .collect(Collectors.toList())) + "]" + ")");/**/
	 }
	  else {
		  return "pred_call[]";
	 }
  }

  @Override
  public String visit(QtExpr n, Object arg) {
	//  inVar = true;
    String qtExpr = n.getOp() + String.join(COMMA,
        n.getVarDecls().stream().map(varDecl -> varDecl.accept(this, arg))
            .collect(Collectors.toList())) + " " + n.getBody().accept(this, arg);
    // {v: D | F} is comprehension
    if (n.getOp() == QtExpr.Quantifier.COMPREHENSION) {
      qtExpr = "{ " + qtExpr + " }";
    }
   // inVar = false;
    return putInMap(n, "(" + qtExpr + ")");
  }

  @Override
  public String visit(QtFormula n, Object arg) {
	  
	 // inVar = true;
	  String res =  n.getOp() + String.join(COMMA,
		        n.getVarDecls().stream().map(varDecl -> varDecl.accept(this, arg))
	            .collect(Collectors.toList())) + " " + n.getBody().accept(this, arg);
	  
	  if(inVar) {
		  if(n.getOp() == QtFormula.Quantifier.ALL) {
			    if(!quant_all_templates.containsKey(res)) {
			    	quant_all_templates.put(res, 0);
			    }
			    quant_all_templates.put(res, quant_all_templates.get(res) + 1);
		  }
		  else if(n.getOp() == QtFormula.Quantifier.LONE) {
			    if(!quant_lone_templates.containsKey(res)) {
			    	quant_lone_templates.put(res, 0);
			    }
			    quant_lone_templates.put(res, quant_lone_templates.get(res) + 1);
		  }
		  else if(n.getOp() == QtFormula.Quantifier.NO) {
			    if(!quant_no_templates.containsKey(res)) {
			    	quant_no_templates.put(res, 0);
			    }
			    quant_no_templates.put(res, quant_no_templates.get(res) + 1);
		  }
		  else if(n.getOp() == QtFormula.Quantifier.ONE) {
			    if(!quant_one_templates.containsKey(res)) {
			    	quant_one_templates.put(res, 0);
			    }
			    quant_one_templates.put(res, quant_one_templates.get(res) + 1);
		  }
		  else if(n.getOp() == QtFormula.Quantifier.SOME) {
			    if(!quant_some_templates.containsKey(res)) {
			    	quant_some_templates.put(res, 0);
			    }
			    quant_some_templates.put(res, quant_some_templates.get(res) + 1);
		  }
	  }
	  //inVar = false;
	  
	  
    
    return putInMap(n, "(" + res + ")");
  }

  @Override
  public String visit(ITEExpr n, Object arg) {
    return putInMap(n,
        "(" + n.getCondition().accept(this, arg) + " => " + n.getThenClause().accept(this, arg)
            + " else " + n.getElseClause().accept(this, arg) + ")");
  }

  @Override
  public String visit(ITEFormula n, Object arg) {
	  
	  String res = n.getCondition().accept(this, arg) + " => " + n.getThenClause().accept(this, arg)
	            + " else " + n.getElseClause().accept(this, arg);
	  
	  if(inVar) {
		  if(!if_else_templates.containsKey(res)) {
		  if_else_templates.put(res, 0);
	    }
	  if_else_templates.put(res, if_else_templates.get(res) + 1);
	  }
	  
	    
    return putInMap(n,res);
  }

  @Override
  public String visit(LetExpr n, Object arg) {
	  
	//  inVar = true;
	  
	String res = "let " + n.getVar().accept(this, arg) + " = " + n.getBound().accept(this, arg) + " " + n
            .getBody().accept(this, arg);
	  
    if(!let_templates.containsKey(res)) {
    	let_templates.put(res, 0);
    }
    let_templates.put(res, let_templates.get(res) + 1);

  //  inVar = false;
    
    return putInMap(n,res);
  }

  @Override
  public String visit(ConstExpr n, Object arg) {
    return putInMap(n, n.getValue());
  }

  @Override
  public String visit(Body n, Object arg) {
    String aux = formatting.isUsingNewLine() ? NEW_LINE : "";
    return putInMap(n, "{" + aux + n.getBodyExpr().accept(this, arg) + aux + "}");
  }

  @Override
  public String visit(Predicate n, Object arg) {
    List<ParamDecl> paramDeclList = n.getParamList();
    if (!paramDeclList.isEmpty()) {
      ParamDecl paramDecl = paramDeclList.get(0);
      if (paramDecl.getNames().size() == 1 && paramDecl.getNames().get(0).equals("this")) {
        return putInMap(n,
            "pred " + paramDecl.getExpr().accept(this, arg) + "." + n.getName()
                .replaceAll("\\" + DOLLAR, UNDERSCORE) + "[" + String.join(COMMA,
                paramDeclList.subList(1, paramDeclList.size()).stream()
                    .map(parameter -> parameter.accept(this, arg))
                    .collect(Collectors.toList())) + "] " + n.getBody().accept(this, arg));
      }
    }
    return putInMap(n,
        "pred " + n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE) + "[" + String.join(COMMA,
            n.getParamList().stream().map(parameter -> parameter.accept(this, arg))
                .collect(Collectors.toList())) + "] " + n.getBody().accept(this, arg));
  }

  @Override
  public String visit(Function n, Object arg) {
    List<ParamDecl> paramDeclList = n.getParamList();
    if (!paramDeclList.isEmpty()) {
      ParamDecl paramDecl = paramDeclList.get(0);
      if (paramDecl.getNames().size() == 1 && paramDecl.getNames().get(0).equals("this")) {
        return putInMap(n,
            "fun " + paramDecl.getExpr().accept(this, arg) + "." + n.getName()
                .replaceAll("\\" + DOLLAR, UNDERSCORE) + "[" + String.join(COMMA,
                paramDeclList.subList(1, paramDeclList.size()).stream()
                    .map(parameter -> parameter.accept(this, arg))
                    .collect(Collectors.toList())) + "] : " + n.getReturnType().accept(this, arg)
                + " " + n.getBody().accept(this, arg));
      }
    }
    return putInMap(n,
        "fun " + n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE) + "[" + String.join(COMMA,
            n.getParamList().stream().map(parameter -> parameter.accept(this, arg))
                .collect(Collectors.toList())) + "] : " + n.getReturnType().accept(this, arg) + " "
            + n.getBody().accept(this, arg));
  }

  @Override
  public String visit(Fact n, Object arg) {
    return putInMap(n,
        "fact " + n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE) + " " + n.getBody()
            .accept(this, arg));
  }

  @Override
  public String visit(Assertion n, Object arg) {
    return putInMap(n,
        "assert " + n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE) + " " + n.getBody()
            .accept(this, arg));
  }

  @Override
  public String visit(Run n, Object arg) {
	//  return putInMap(n,
		//	  "run " + n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE) + n.getScopeAsString());
	  String name = n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE);
	  String formula = n.getFormula().accept(this,arg);
	  if(formula.equals("()"))
		  formula = "";
	  return putInMap(n,
		"pred run_" + name + " { " + formula + " }\n" + name + ": run "  + "run_" + name + n.getScopeAsString());		
  }

  @Override
  public String visit(Check n, Object arg) {
    //return putInMap(n,
        //"check " + n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE) + n.getScopeAsString());
	  String formula = n.getFormula().accept(this,arg);
	  if(formula.equals("()"))
		  formula = "";
	  String name = n.getName().replaceAll("\\" + DOLLAR, UNDERSCORE);
    return putInMap(n,
	  "assert check_" + name + " { " + formula + " } \n " + name + ": check "  + "check_" + name + n.getScopeAsString());		

  }
}