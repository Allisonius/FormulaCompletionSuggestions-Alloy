package alloy.language.server;

import org.eclipse.lsp4j.*;
import org.eclipse.lsp4j.services.*;
import org.slf4j.Logger;

import java.util.Arrays;
import java.util.concurrent.CompletableFuture;

public class AlloyLanguageServer implements LanguageServer, LanguageClientAware {
    private AlloyLanguageClient client;
    private final AlloyTextDocumentService textDocumentService;
    private final AlloyWorkspaceService workspaceService;
    private final Logger logger = org.slf4j.LoggerFactory.getLogger(getClass());

    public AlloyLanguageServer() {
        this.textDocumentService = new AlloyTextDocumentService(this);
        this.workspaceService = new AlloyWorkspaceService(this);
    }

    @Override
    public CompletableFuture<InitializeResult> initialize(InitializeParams initializeParams) {
        logger.info("INITIALIZE");
        return CompletableFuture.supplyAsync(() -> {
            logger.info("INITIALIZE SUPPLY ASYNC");
            client.logMessage(new MessageParams(MessageType.Info, "Alloy Language Server initialized"));
            return new InitializeResult(createServerCapabilities());
        });
    }

    private ServerCapabilities createServerCapabilities() {
        ServerCapabilities capabilities = new ServerCapabilities();
        capabilities.setTextDocumentSync(TextDocumentSyncKind.Full);
        capabilities.setCompletionProvider(new CompletionOptions(Boolean.FALSE, Arrays.asList(".", "&", "=", ":", "->", "in", "extends")));
        capabilities.setDefinitionProvider(Boolean.FALSE);
        capabilities.setHoverProvider(Boolean.FALSE);
        capabilities.setReferencesProvider(Boolean.FALSE);
        capabilities.setDocumentSymbolProvider(Boolean.FALSE);
        capabilities.setFoldingRangeProvider(Boolean.FALSE);

        capabilities.setCodeLensProvider(new CodeLensOptions(Boolean.TRUE));
//        capabilities.setDocumentSymbolProvider(new DocumentSymbolOptions("Camel"));
//        capabilities.setCodeActionProvider(new CodeActionOptions(Arrays.asList(CodeActionKind.QuickFix)));
//        capabilities.setFoldingRangeProvider(Boolean.TRUE);
        return capabilities;
    }


    @Override
    public CompletableFuture<Object> shutdown() {
        logger.info("SHUTDOWN");
        return CompletableFuture.supplyAsync(() -> Boolean.TRUE);
        // return CompletableFuture.completedFuture(null);
    }

    @Override
    public void exit() {
        logger.info("EXIT");
        System.exit(0);
    }

    @Override
    public TextDocumentService getTextDocumentService() {
        logger.info("GET TEXT DOCUMENT SERVICE");
        return this.textDocumentService;
    }

    @Override
    public WorkspaceService getWorkspaceService() {
        logger.info("GET WORKSPACE SERVICE");
        return this.workspaceService;
    }

    @Override
    public void connect(LanguageClient client) {
        this.client = (AlloyLanguageClient) client;
        LanguageClientRegistry.getInstance().setClient(this.client);
        logger.info("CONNECT");
    }

    public AlloyLanguageClient getClient() {
        return client;
    }
}
