package arepair.generator.util.rules.difference;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.*;

public class DRule4 extends BinaryRule {

  private DRule4(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static DRule4 given(BinaryInfo binaryInfo) {
    return new DRule4(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(rightRel.getOp(), PLUS, AMP, MINUS)
        && (sameRelations(leftRel, getChild(rightRel, 0))
        || sameRelations(leftRel, getChild(rightRel, 1)));
  }
}
