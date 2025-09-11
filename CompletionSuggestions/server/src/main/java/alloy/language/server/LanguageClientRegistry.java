package alloy.language.server;

public class LanguageClientRegistry {
    private static final LanguageClientRegistry INSTANCE = new LanguageClientRegistry();
    private volatile AlloyLanguageClient client;

    private LanguageClientRegistry() {}

    public static LanguageClientRegistry getInstance() {
        return INSTANCE;
    }

    public void setClient(AlloyLanguageClient client) {
        this.client = client;
    }

    public AlloyLanguageClient getClient() {
        return client;
    }
}
