package alloy.language.server.params.requests;

import org.eclipse.lsp4j.Position;
import org.eclipse.lsp4j.Range;
import org.eclipse.lsp4j.TextDocumentIdentifier;
import org.eclipse.lsp4j.TextDocumentPositionAndWorkDoneProgressAndPartialResultParams;
import org.eclipse.lsp4j.jsonrpc.validation.NonNull;
import org.eclipse.lsp4j.util.ToStringBuilder;

import java.util.Objects;

public class AlloyCompletionItemSelectedParams extends TextDocumentPositionAndWorkDoneProgressAndPartialResultParams {
	public enum InlineCompletionTriggerKind {
		Invoked(1), Automatic(2);

		private final int value;

		InlineCompletionTriggerKind(int value) {
			this.value = value;
		}

		public int getValue() {
			return value;
		}

		public static InlineCompletionTriggerKind fromValue(int value) {
			for (InlineCompletionTriggerKind kind : InlineCompletionTriggerKind.values()) {
				if (kind.getValue() == value) {
					return kind;
				}
			}
			return null;
		}
	}

	public static class SelectedCompletionInfo {
		private Range range;
		private String text;

		public SelectedCompletionInfo() {
		}

		public SelectedCompletionInfo(@NonNull Range range, @NonNull String text) {
			this.range = range;
			this.text = text;
		}

		public Range getRange() {
			return range;
		}

		public void setRange(@NonNull Range range) {
			this.range = range;
		}

		public String getText() {
			return text;
		}

		public void setText(@NonNull String text) {
			this.text = text;
		}

		@Override
		public String toString() {
			ToStringBuilder b = new ToStringBuilder(this);
			b.add("range", this.range);
			b.add("text", this.text);
			return b.toString();
		}

		@Override
		public boolean equals(Object o) {
			if (this == o) {
				return true;
			}
			if (o == null || getClass() != o.getClass()) {
				return false;
			}
			SelectedCompletionInfo that = (SelectedCompletionInfo) o;
			return range.equals(that.range) && text.equals(that.text);
		}

		@Override
		public int hashCode() {
			return Objects.hash(range, text);
		}
	}

	private InlineCompletionTriggerKind triggerKind;
	private SelectedCompletionInfo selectedCompletionInfo;

	public AlloyCompletionItemSelectedParams() {
	}

	public AlloyCompletionItemSelectedParams(
			@NonNull final TextDocumentIdentifier textDocument, @NonNull final Position position) {
		super(textDocument, position);
	}

	public AlloyCompletionItemSelectedParams(
			@NonNull final TextDocumentIdentifier textDocument, @NonNull final Position position,
			final InlineCompletionTriggerKind triggerKind, final SelectedCompletionInfo selectedCompletionInfo) {
		this(textDocument, position);
		this.triggerKind = triggerKind;
		this.selectedCompletionInfo = selectedCompletionInfo;
	}

	public InlineCompletionTriggerKind getTriggerKind() {
		return triggerKind;
	}

	public void setTriggerKind(InlineCompletionTriggerKind triggerKind) {
		this.triggerKind = triggerKind;
	}

	public SelectedCompletionInfo getSelectedCompletionInfo() {
		return selectedCompletionInfo;
	}

	public void setSelectedCompletionInfo(SelectedCompletionInfo selectedCompletionInfo) {
		this.selectedCompletionInfo = selectedCompletionInfo;
	}

	@Override
	public String toString() {
		ToStringBuilder b = new ToStringBuilder(this);
		b.add("textDocument", this.getTextDocument());
		b.add("position", this.getPosition());
		b.add("triggerKind", this.triggerKind);
		b.add("selectedCompletionInfo", this.selectedCompletionInfo);
		return b.toString();
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		AlloyCompletionItemSelectedParams that = (AlloyCompletionItemSelectedParams) o;
		return getTextDocument().equals(that.getTextDocument()) && getPosition().equals(that.getPosition())
				&& triggerKind == that.triggerKind && selectedCompletionInfo.equals(that.selectedCompletionInfo);
	}

	@Override
	public int hashCode() {
		return getTextDocument().hashCode() + getPosition().hashCode() + triggerKind.hashCode() + selectedCompletionInfo.hashCode();
	}
}
