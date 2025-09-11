package alloy.language.server;

import org.eclipse.lsp4j.jsonrpc.services.JsonNotification;
import org.eclipse.lsp4j.services.LanguageClient;

public interface AlloyLanguageClient extends LanguageClient {

	@JsonNotification(value = "alloy/updateModel", useSegment = false)
	void updateModel(String message);
}
