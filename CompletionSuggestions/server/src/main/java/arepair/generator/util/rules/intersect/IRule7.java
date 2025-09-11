package arepair.generator.util.rules.intersect;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.*;

public class IRule7 extends BinaryRule {

  private IRule7(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static IRule7 given(BinaryInfo binaryInfo) {
    return new IRule7(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return (opIsOr(leftRel.getOp(), STAR, CARET) && sameRelations(getChild(leftRel, 0),
        duplicateNodesUnderOps(rightRel, DOT)))
        || (opIsOr(rightRel.getOp(), STAR, CARET) && sameRelations(getChild(rightRel, 0),
        duplicateNodesUnderOps(leftRel, DOT)));
  }
}
