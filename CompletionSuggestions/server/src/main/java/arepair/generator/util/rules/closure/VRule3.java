package arepair.generator.util.rules.closure;

import arepair.generator.util.rules.UnaryInfo;
import arepair.generator.util.rules.UnaryRule;

import static arepair.generator.etc.Constants.IDEN_EXPR;

public class VRule3 extends UnaryRule {

  private VRule3(UnaryInfo unaryInfo) {
    super(unaryInfo);
  }

  public static VRule3 given(UnaryInfo unaryInfo) {
    return new VRule3(unaryInfo);
  }

  @Override
  public boolean isPruned() {
    return rel == IDEN_EXPR;
  }
}
