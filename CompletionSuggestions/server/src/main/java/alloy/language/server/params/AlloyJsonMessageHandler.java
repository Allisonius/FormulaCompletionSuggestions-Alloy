package alloy.language.server.params;

import com.google.gson.GsonBuilder;
import org.eclipse.lsp4j.jsonrpc.json.JsonRpcMethod;
import org.eclipse.lsp4j.jsonrpc.json.MessageJsonHandler;

import java.util.Map;
import java.util.function.Consumer;

public class AlloyJsonMessageHandler extends MessageJsonHandler {
	public AlloyJsonMessageHandler(
			Map<String, JsonRpcMethod> supportedMethods) {
		super(supportedMethods);
	}

	public AlloyJsonMessageHandler(
			Map<String, JsonRpcMethod> supportedMethods, Consumer<GsonBuilder> configureGson) {
		super(supportedMethods, configureGson);
	}

	@Override
	public JsonRpcMethod getJsonRpcMethod(String name) {
		return super.getJsonRpcMethod(name);
	}
}
