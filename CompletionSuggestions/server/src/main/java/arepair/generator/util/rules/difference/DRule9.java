package arepair.generator.util.rules.difference;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.TILDE;

public class DRule9 extends BinaryRule {

  private DRule9(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static DRule9 given(BinaryInfo binaryInfo) {
    return new DRule9(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(leftRel.getOp(), TILDE) && opIsOr(rightRel.getOp(), TILDE);
  }
}
