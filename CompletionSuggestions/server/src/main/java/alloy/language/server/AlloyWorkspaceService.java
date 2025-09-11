package alloy.language.server;


import org.eclipse.lsp4j.*;
import org.eclipse.lsp4j.jsonrpc.messages.Either;
import org.eclipse.lsp4j.services.WorkspaceService;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public class AlloyWorkspaceService implements WorkspaceService {
    private AlloyLanguageServer languageServer;

    public AlloyWorkspaceService(AlloyLanguageServer languageServer) {
        this.languageServer = languageServer;
    }

    public void didChangeConfiguration(DidChangeConfigurationParams didChangeConfigurationParams) {
//        System.out.println("Operation '" + "workspace/didChangeConfiguration" +
//                "' {fileUri: '" + didChangeConfigurationParams.getSettings() + "'} Changed");
    }

    public void didChangeWatchedFiles(DidChangeWatchedFilesParams didChangeWatchedFilesParams) {
//        System.out.println("Operation '" + "workspace/didChangeWatchedFiles" +
//                "' {fileUri: '" + didChangeWatchedFilesParams.getChanges() + "'} Changed");
    }

    public CompletableFuture<Either<List<? extends SymbolInformation>, List<? extends WorkspaceSymbol>>> symbol(WorkspaceSymbolParams workspaceSymbolParams) {
//        System.out.println("Operation '" + "workspace/symbol" +
//                "' {fileUri: '" + workspaceSymbolParams.getQuery() + "'} Changed");
        return null;
    }

    public CompletableFuture<Object> executeCommand(ExecuteCommandParams executeCommandParams) {
//        System.out.println("Operation '" + "workspace/executeCommand" +
//                "' {fileUri: '" + executeCommandParams.getCommand() + "'} Changed");
        return null;
    }

    public void didChangeWorkspaceFolders(DidChangeWorkspaceFoldersParams didChangeWorkspaceFoldersParams) {
//        System.out.println("Operation '" + "workspace/didChangeWorkspaceFolders" +
//                "' {fileUri: '" + didChangeWorkspaceFoldersParams.getEvent() + "'} Changed");
    }

    public void didChangeConfiguration(Object settings) {
//        System.out.println("Operation '" + "workspace/didChangeConfiguration" +
//                "' {fileUri: '" + settings + "'} Changed");
    }

    public void didChangeWatchedFiles(Object changes) {
//        System.out.println("Operation '" + "workspace/didChangeWatchedFiles" +
//                "' {fileUri: '" + changes + "'} Changed");
    }

    public void symbol(Object query) {
//        System.out.println("Operation '" + "workspace/symbol" +
//                "' {fileUri: '" + query + "'} Changed");
    }

    public void executeCommand(Object command) {
//        System.out.println("Operation '" + "workspace/executeCommand" +
//                "' {fileUri: '" + command + "'} Changed");
    }

//    @Override
    public void didRenameFiles(RenameFilesParams params) {
//        System.out.println("Operation 'workspace/didRenameFiles' Ack");
    }

}
