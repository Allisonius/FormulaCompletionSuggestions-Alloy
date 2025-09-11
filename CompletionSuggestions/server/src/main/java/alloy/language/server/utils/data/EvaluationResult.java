package alloy.language.server.utils.data;

import alloy.language.server.utils.CodeUtils;
import edu.mit.csail.sdg.translator.A4TupleSet;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;

import java.util.Objects;

public class EvaluationResult {
	private final String value;
	private final A4TupleSet atoms;
	private final boolean formula;
	private String sortKey;

	public EvaluationResult(String value, String sortKey) {
		this.value = value;
		this.atoms = null;
		this.formula = false;
		this.sortKey = sortKey;
	}

	public EvaluationResult(String value, A4TupleSet atoms, boolean formula) {
		this.value = value;
		this.atoms = atoms;
		this.formula = formula;
	}

	public EvaluationResult(String value, A4TupleSet atoms, boolean formula, String sortKey) {
		this.value = value;
		this.atoms = atoms;
		this.formula = formula;
		this.sortKey = sortKey;
	}

	public String getValue() {
		return value;
	}

	public A4TupleSet getAtoms() {
		return atoms;
	}

	public boolean isFormula() {
		return formula;
	}

	public String getSortKey() {
		return sortKey;
	}

	public CompletionItem toCompletionItemOfVariableKind() {
		CompletionItem completionItem = new CompletionItem();
		completionItem.setLabel(CodeUtils.formatLabel(this.getValue()));
		completionItem.setKind(CompletionItemKind.Variable);
		if (!formula && this.getAtoms() != null) completionItem.setDetail(this.getAtoms().toString());
		completionItem.setSortText(this.getSortKey());
		// TODO 5/11/25: Use a config flag to enable/disable this feature in debug mode
//		var calledFrom = Arrays.stream(Thread.currentThread().getStackTrace())
//		                       .filter(st -> st.getClassName().startsWith("alloy.language.server.visitors"))
//		                       .map(st -> {
//			                       var classNames = st.getClassName().split("\\.");
//			                       return classNames[classNames.length - 1];
//		                       })
//		                       .findFirst();
//		calledFrom.ifPresent(completionItem::setDetail);
		return completionItem;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (!(o instanceof EvaluationResult)) return false;
		EvaluationResult that = (EvaluationResult) o;
		return value.equals(that.value);
	}

	@Override
	public int hashCode() {
		return Objects.hash(value);
	}
}