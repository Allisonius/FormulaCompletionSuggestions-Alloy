package arepair.generator.util.rules.crossproduct;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.DOT;

public class CRule2 extends BinaryRule {

  private CRule2(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static CRule2 given(BinaryInfo binaryInfo) {
    return new CRule2(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(leftRel.getOp(), DOT) || opIsOr(rightRel.getOp(), DOT);
  }
}
