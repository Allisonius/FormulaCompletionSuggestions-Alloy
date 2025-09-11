package arepair.generator.util.rules.intersect;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.TILDE;

public class IRule6 extends BinaryRule {

  private IRule6(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static IRule6 given(BinaryInfo binaryInfo) {
    return new IRule6(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(leftRel.getOp(), TILDE) && opIsOr(rightRel.getOp(), TILDE);
  }
}
