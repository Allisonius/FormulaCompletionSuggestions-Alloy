package arepair.generator.util.rules.rclosure;

import arepair.generator.util.rules.UnaryInfo;
import arepair.generator.util.rules.UnaryRule;

import static arepair.generator.etc.Constants.CARET;
import static arepair.generator.etc.Constants.STAR;

public class RRule1 extends UnaryRule {

  private RRule1(UnaryInfo unaryInfo) {
    super(unaryInfo);
  }

  public static RRule1 given(UnaryInfo unaryInfo) {
    return new RRule1(unaryInfo);
  }

  @Override
  public boolean isPruned() {
    return opIsOr(rel.getOp(), STAR, CARET);
  }
}
