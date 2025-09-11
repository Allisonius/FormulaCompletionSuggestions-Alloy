package alloy.language.server.utils.data;

import arepair.generator.CompatUtils;
import arepair.generator.fragment.Expression;
import arepair.generator.util.Util;
import edu.mit.csail.sdg.ast.Type;

import java.util.Objects;

public class SuggestionTerm {
	public enum Degree {
		QUANTIFIER, SIG, RELATION, EXTENDED_RELATION_1, EXTENDED_RELATION_2, EXTENDED_RELATION_3, BUILT_IN
	}

	private final String label;
	private final Type type;
	private final Degree degree;
	private Expression expression;

	public SuggestionTerm(String label, Type type, Degree degree) {
		this.label = label;
		this.type = type;
		this.degree = degree;
		this.expression = null;
	}

	public SuggestionTerm(String label, Type type, Degree degree, Expression expression) {
		this.label = label;
		this.type = type;
		this.degree = degree;
		this.expression = expression;
	}

	public String getLabel() {
		return label;
	}

	public Type getType() {
		return type;
	}

	public Degree getDegree() {
		return degree;
	}

	public String getSortKey() {
		return String.valueOf(degree.ordinal());
	}

	public Expression getExpression() {
		return expression;
	}

	public void setExpression(Expression expression) {
		this.expression = expression;
	}

	@Override
	public String toString() {
		return "SuggestionTerm{" + "label='" + label + '\'' + ", type=" + type + '}';
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (!(o instanceof SuggestionTerm)) return false;
		SuggestionTerm that = (SuggestionTerm) o;
		return label.equals(that.label);
	}

	@Override
	public int hashCode() {
		return Objects.hash(label);
	}
}