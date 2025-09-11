package arepair.generator.util.rules.difference;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.AMP;

public class DRule11 extends BinaryRule {

  private DRule11(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static DRule11 given(BinaryInfo binaryInfo) {
    return new DRule11(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(leftRel.getOp(), AMP);
  }
}
