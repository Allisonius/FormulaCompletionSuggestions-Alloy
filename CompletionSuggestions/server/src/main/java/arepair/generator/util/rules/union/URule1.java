package arepair.generator.util.rules.union;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.PLUS;

public class URule1 extends BinaryRule {

  private URule1(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static URule1 given(BinaryInfo binaryInfo) {
    return new URule1(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return leftRel.getOp().equals(PLUS);
  }
}
