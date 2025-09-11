package arepair.generator.util.rules.crossproduct;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.ARROW;

public class CRule1 extends BinaryRule {

  private CRule1(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static CRule1 given(BinaryInfo binaryInfo) {
    return new CRule1(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(leftRel.getOp(), ARROW);
  }
}
