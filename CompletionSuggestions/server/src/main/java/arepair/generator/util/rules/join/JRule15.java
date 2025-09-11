package arepair.generator.util.rules.join;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.etc.Constants.IDEN_EXPR;

public class JRule15 extends BinaryRule {

  private JRule15(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static JRule15 given(BinaryInfo binaryInfo) {
    return new JRule15(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return leftRel == IDEN_EXPR || rightRel == IDEN_EXPR;
  }
}
