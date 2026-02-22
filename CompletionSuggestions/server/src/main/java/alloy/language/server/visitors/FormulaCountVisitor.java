package alloy.language.server.visitors;

import alloy.language.server.alloyBaseVisitor;
import alloy.language.server.alloyParser;

import java.util.concurrent.atomic.AtomicInteger;

public class FormulaCountVisitor extends alloyBaseVisitor<Integer> {
	protected String alloyText;

	private final AtomicInteger formulaCount = new AtomicInteger(0);

	public FormulaCountVisitor(String alloyText) {
		this.alloyText = alloyText;
	}

	private void countFormulasInBlock(alloyParser.BlockContext block) {
		if (block.expr() != null) {
			formulaCount.addAndGet(block.expr().size());
		}
	}

	@Override
	public Integer visitPredDecl(alloyParser.PredDeclContext ctx) {
		if (ctx.block() != null) {
			countFormulasInBlock(ctx.block());
		}
		return super.visitPredDecl(ctx);
	}

	@Override
	public Integer visitFactDecl(alloyParser.FactDeclContext ctx) {
		if (ctx.block() != null) {
			countFormulasInBlock(ctx.block());
		}
		return super.visitFactDecl(ctx);
	}

	@Override
	protected Integer aggregateResult(Integer aggregate, Integer nextResult) {
		return formulaCount.get();
	}
}
