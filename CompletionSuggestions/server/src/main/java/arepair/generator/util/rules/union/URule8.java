package arepair.generator.util.rules.union;

import arepair.generator.util.rules.BinaryInfo;
import arepair.generator.util.rules.BinaryRule;

import static arepair.generator.util.Util.buildExpression;

public class URule8 extends BinaryRule {

  private URule8(BinaryInfo binaryInfo) {
    super(binaryInfo);
  }

  public static URule8 given(BinaryInfo binaryInfo) {
    return new URule8(binaryInfo);
  }

  @Override
  public boolean isPruned() {
    return !uniqueNodesUnderOps(buildExpression(-1, op, leftRel, rightRel, inheritanceMap), op);
  }
}
