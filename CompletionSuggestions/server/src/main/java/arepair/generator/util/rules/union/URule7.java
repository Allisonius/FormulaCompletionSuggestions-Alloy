package arepair.generator.util.rules.union;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.*;

public class URule7 extends BinaryRule {

  private URule7(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static URule7 given(BinaryInfo binaryInfo) {
    return new URule7(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return (opIsOr(leftRel.getOp(), STAR, CARET) && getChild(leftRel, 0)
        .equals(duplicateNodesUnderOps(rightRel, DOT)))
        || (opIsOr(rightRel.getOp(), STAR, CARET) && getChild(rightRel, 0)
        .equals(duplicateNodesUnderOps(leftRel, DOT)));
  }
}
