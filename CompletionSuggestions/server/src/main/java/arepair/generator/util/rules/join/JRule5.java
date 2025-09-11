package arepair.generator.util.rules.join;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.CARET;
import static arepair.generator.util.Util.isSuperType;

public class JRule5 extends BinaryRule {

  private JRule5(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static JRule5 given(BinaryInfo binaryInfo) {
    return new JRule5(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return isSuperType(leftRel, inheritanceMap) && opIsOr(rightRel.getOp(), CARET)
        || isSuperType(rightRel, inheritanceMap) && opIsOr(leftRel.getOp(), CARET);
  }
}
