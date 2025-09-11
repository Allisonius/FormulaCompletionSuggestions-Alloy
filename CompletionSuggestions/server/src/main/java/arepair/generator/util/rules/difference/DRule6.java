package arepair.generator.util.rules.difference;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.AMP;
import static arepair.generator.etc.Constants.ARROW;

public class DRule6 extends BinaryRule {

  private DRule6(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static DRule6 given(BinaryInfo binaryInfo) {
    return new DRule6(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    // Remove the case where a.b - a.c
    return (opIsOr(leftRel.getOp(), ARROW) && opIsOr(rightRel.getOp(), ARROW)
        || opIsOr(leftRel.getOp(), AMP) && opIsOr(rightRel.getOp(), AMP))
        && (sameRelations(getChild(leftRel, 0), getChild(rightRel, 0))
        || sameRelations(getChild(leftRel, 1), getChild(rightRel, 1)));
  }
}
