package alloy.language.server;

public class ConfigManager {

    private static ConfigManager instance;

    private boolean enableMultiTermCompletion = false;
    private boolean enableVerbose = false;
    private boolean logToClient = false;
    private boolean useGeneratorCompletion = false;

    private ConfigManager() {
        // Load config values from a file, database, or other source
        // For example:
        // configValue1 = readFromFile("config.txt");
        // configValue2 = readFromDatabase("config_table");
    }

    public static synchronized ConfigManager getInstance() {
        if (instance == null) {
            instance = new ConfigManager();
        }
        return instance;
    }

    public boolean isEnableMultiTermCompletion() {
        return enableMultiTermCompletion;
    }

    public void setEnableMultiTermCompletion(boolean enableMultiTermCompletion) {
        this.enableMultiTermCompletion = enableMultiTermCompletion;
    }

    public boolean isEnableVerbose() {
        return enableVerbose;
    }

    public void setEnableVerbose(boolean enableVerbose) {
        this.enableVerbose = enableVerbose;
    }

    public boolean isLogToClient() {
        return logToClient;
    }

    public void setLogToClient(boolean logToClient) {
        this.logToClient = logToClient;
    }

    public boolean useGeneratorCompletion() {
        return useGeneratorCompletion;
    }

    public void setUseGeneratorCompletion(boolean useGeneratorCompletion) {
        this.useGeneratorCompletion = useGeneratorCompletion;
    }
}
