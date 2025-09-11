package arepair.generator.util.rules.difference;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.util.Util.isSuperType;

public class DRule1 extends BinaryRule {

  private DRule1(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static DRule1 given(BinaryInfo binaryInfo) {
    return new DRule1(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return isSuperType(rightRel, inheritanceMap)
        // Remove the case where *a - A->A
        && rightRel.getArity() == 1;
  }
}
