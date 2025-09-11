package alloy.language.server;

import org.eclipse.lsp4j.*;
import org.eclipse.lsp4j.jsonrpc.Launcher;
import org.eclipse.lsp4j.jsonrpc.messages.Either;
import org.eclipse.lsp4j.launch.LSPLauncher;
import org.eclipse.lsp4j.services.LanguageClient;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.concurrent.ExecutionException;

public class LanguageServerBasicTest {

    AlloyLanguageServer server;
    Launcher<AlloyLanguageClient> launcher;

    @BeforeEach
    void setUp() throws ExecutionException, InterruptedException {
        server = new AlloyLanguageServer();
        launcher = Launcher.createLauncher(server, AlloyLanguageClient.class, System.in, System.out);
        server.connect(launcher.getRemoteProxy());
        launcher.startListening().get();
    }

    @AfterEach
    void tearDown() {
        server.exit();
    }

    @Test
    void testInitializeWithRequestMessage() {
        InitializeParams initializeParams = new InitializeParams();
        initializeParams.setProcessId(1);
        server.initialize(initializeParams);
        launcher.getRemoteEndpoint().request("initialize", initializeParams);
    }
}
