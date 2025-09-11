package arepair.generator.util.rules.join;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.TILDE;
import static arepair.generator.util.Util.buildExpression;

public class JRule9 extends BinaryRule {

  private JRule9(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static JRule9 given(BinaryInfo binaryInfo) {
    return new JRule9(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return consecutiveNodesUnderOps(buildExpression(-1, op, leftRel, rightRel, inheritanceMap), op,
        (prev, cur) -> opIsOr(prev.getOp(), TILDE) && opIsOr(cur.getOp(), TILDE));
  }
}
