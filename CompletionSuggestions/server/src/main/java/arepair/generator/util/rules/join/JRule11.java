package arepair.generator.util.rules.join;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.ARROW;
import static arepair.generator.etc.Constants.MINUS;

public class JRule11 extends BinaryRule {

  private JRule11(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static JRule11 given(BinaryInfo binaryInfo) {
    return new JRule11(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(rightRel.getOp(), ARROW) && rightChildUnderLeftImbalancedOps(
        getChild(rightRel, 0), MINUS, root -> sameRelations(leftRel, getChild(root, 1)))
        || opIsOr(leftRel.getOp(), ARROW) && rightChildUnderLeftImbalancedOps(
        getChild(leftRel, 1), MINUS, root -> sameRelations(getChild(root, 1), rightRel));
  }
}
