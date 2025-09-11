package arepair.generator.util.rules.closure;

import arepair.generator.util.rules.UnaryInfo;
import arepair.generator.util.rules.UnaryRule;

import static arepair.generator.etc.Constants.ARROW;

public class VRule2 extends UnaryRule {

  private VRule2(UnaryInfo unaryInfo) {
    super(unaryInfo);
  }

  public static VRule2 given(UnaryInfo unaryInfo) {
    return new VRule2(unaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(rel.getOp(), ARROW);
  }
}
