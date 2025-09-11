package alloy.language.server.params.requests;

import org.eclipse.lsp4j.jsonrpc.validation.NonNull;

public class AlloyLegacyVizParams {
	@NonNull
	String documentUri;
	String command;
	boolean isNextInstance = false;

	public AlloyLegacyVizParams() {
	}

	public AlloyLegacyVizParams(@NonNull final String documentUri) {
		this(documentUri, "Run {} for 3");
	}

	public AlloyLegacyVizParams(@NonNull final String documentUri, String command) {
		this.documentUri = documentUri;
		this.command = command;
	}

	public AlloyLegacyVizParams(@NonNull final String documentUri, String command, boolean isNextInstance) {
		this.documentUri = documentUri;
		this.command = command;
		this.isNextInstance = isNextInstance;
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

	public boolean isNextInstance() {
		return isNextInstance;
	}

	public void setNextInstance(boolean isNextInstance) {
		this.isNextInstance = isNextInstance;
	}


	public String toString() {
		return "AlloyLegacyVizParams{" + "documentUri='" + documentUri + '\'' + ", command='" + command + '\'' +
		       ", isNextInstance=" + isNextInstance + '}';
	}
}
