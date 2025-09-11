package parser.ast.nodes;

import edu.mit.csail.sdg.ast.ExprUnary;
import edu.mit.csail.sdg.ast.Type;
import parser.ast.nodes.UnaryExpr.UnaryOp;
import parser.ast.visitor.GenericVisitor;
import parser.ast.visitor.VoidVisitor;
import parser.exception.UnsupportedOptionException;

public class UnaryFormula extends UnaryExprOrFormula {

  private static final long serialVersionUID = 3876873263710266585L;
  protected UnaryOp op;

  public UnaryFormula(Node parent, ExprUnary expr) {
    super(parent, expr);
    this.op = findOp(expr);
  }

  public UnaryFormula(Node parent) {
    super(parent);
  }
  
  /**
   * This constructor is only used to create wrapper unary expressions.
   * So it does not have any mapping from the original Alloy node.
   */
  public UnaryFormula(Node parent, Type type, ExprOrFormula sub, UnaryOp op) {
    super(parent, type, sub);
    this.op = op;
  }


  private UnaryOp findOp(ExprUnary expr) {
    switch (expr.op) {
      case LONE:
        return UnaryOp.LONE;
      case ONE:
        return UnaryOp.ONE;
      case SOME:
        return UnaryOp.SOME;
      case NO:
        return UnaryOp.NO;
      case NOT:
        return UnaryOp.NOT;
      /*case BEFORE:
    	  return UnaryOp.BEFORE;
      case HISTORICALLY:
    	  return UnaryOp.HISTORICALLY;
      case ONCE:
    	  return UnaryOp.ONCE;
      case ALWAYS:
    	  return UnaryOp.ALWAYS;
      case EVENTUALLY:
    	  return UnaryOp.EVENTUALLY;
      case AFTER:
    	  return UnaryOp.AFTER;*/
      default:
        throw new UnsupportedOptionException("Unsupported unary operator " + expr.op.toString());
    }
  }

  public UnaryOp getOp() {
    return op;
  }

  public void setOp(UnaryOp op) {
    this.op = op;
  }

  @Override
  public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
    return v.visit(this, arg);
  }

  @Override
  public <A> void accept(VoidVisitor<A> v, A arg) {
    v.visit(this, arg);
  }

  public enum UnaryOp {
    LONE("lone", Group.QUANTIFIED_OPERATION),
    ONE("one", Group.QUANTIFIED_OPERATION),
    SOME("some", Group.QUANTIFIED_OPERATION),
    NO("no", Group.QUANTIFIED_OPERATION),
    NOT("!", Group.OTHER),
    BEFORE("before", Group.TEMPORAL_OPERATOR),
    HISTORICALLY("historically", Group.TEMPORAL_OPERATOR),
    ONCE("once", Group.TEMPORAL_OPERATOR),
    ALWAYS("always", Group.TEMPORAL_OPERATOR),
    EVENTUALLY("eventually", Group.TEMPORAL_OPERATOR),
    AFTER("after", Group.TEMPORAL_OPERATOR),
	NOOP("", Group.IGNORED);


    private String label;
    private Group group;

    UnaryOp(String label, Group group) {
      this.label = label;
      this.group = group;
    }

    @Override
    public String toString() {
      switch (this) {
        case NOT:
          return label;
        default:
          return label + " ";
      }
    }

    public String getLabel() {
      return label;
    }

    public Group getGroup() {
      return group;
    }

    public enum Group {
      QUANTIFIED_OPERATION,
      OTHER,
      IGNORED,
      TEMPORAL_OPERATOR
    }
  }
}
