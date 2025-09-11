package alloy.language.server.completion;

import alloy.language.server.alloyParser;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionParams;

import java.util.List;
import java.util.Map;

public interface CompletionProvider {
    /**
     * Provides completion suggestions based on the given context.
     *
     * @param documentText  The text of the document where completion is requested.
     *                      This is used to analyze the context and provide relevant suggestions.
     * @param position      The position in the document where completion is requested.
     *                      This is used to determine the context of the request.
     * @param quantifierMap A map of quantifiers extracted from the document.
     *                      This is used to provide context-specific suggestions based on the quantifiers present in the document.
     * @return A list of completion suggestions.
     */
    List<CompletionItem> provideCompletions(String documentText,
                                            CompletionParams position,
                                            Map<String, alloyParser.ExprContext> quantifierMap);

}
