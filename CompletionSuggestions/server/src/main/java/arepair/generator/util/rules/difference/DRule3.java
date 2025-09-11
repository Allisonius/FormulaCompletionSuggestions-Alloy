package arepair.generator.util.rules.difference;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.PLUS;

public class DRule3 extends BinaryRule {

  private DRule3(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static DRule3 given(BinaryInfo binaryInfo) {
    return new DRule3(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(rightRel.getOp(), PLUS);
  }
}
