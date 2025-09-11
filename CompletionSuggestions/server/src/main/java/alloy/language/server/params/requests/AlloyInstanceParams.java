package alloy.language.server.params.requests;

import org.eclipse.lsp4j.jsonrpc.validation.NonNull;
import org.eclipse.lsp4j.util.ToStringBuilder;

public class AlloyInstanceParams {

	private static final String DEFAULT_COMMAND = "Run {} for 3";

	@NonNull
	String documentUri;
	String command;
	int state = 0;

	public AlloyInstanceParams() {
	}

	public AlloyInstanceParams(@NonNull final String documentUri) {
		this(documentUri, DEFAULT_COMMAND);
	}

	public AlloyInstanceParams(@NonNull final String documentUri, String command) {
		this.documentUri = documentUri;
		this.command = command;
	}

	public AlloyInstanceParams(@NonNull final String documentUri, String command, int state) {
		this.documentUri = documentUri;
		this.command = command;
		this.state = state;
	}

	public String getDocumentUri() {
		return documentUri;
	}

	public String getCommand() {
		return command;
	}

	public void setDocumentUri(@NonNull String documentUri) {
		this.documentUri = documentUri;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	@Override
	public String toString() {
		ToStringBuilder b = new ToStringBuilder(this);
		b.add("documentUri", this.documentUri);
		b.add("command", this.command);
		b.add("state", this.state);
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
		AlloyInstanceParams that = (AlloyInstanceParams) o;
		return documentUri.equals(that.documentUri) &&
				command.equals(that.command);
	}
}
