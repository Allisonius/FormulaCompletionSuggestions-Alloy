package alloy.language.server;

import ch.qos.logback.core.AppenderBase;
import ch.qos.logback.classic.spi.ILoggingEvent;
import org.eclipse.lsp4j.MessageParams;
import org.eclipse.lsp4j.MessageType;

public class LanguageClientAppender extends AppenderBase<ILoggingEvent> {
    @Override
    protected void append(ILoggingEvent eventObject) {
        AlloyLanguageClient client = LanguageClientRegistry.getInstance().getClient();
        if (client != null && ConfigManager.getInstance().isLogToClient()) {
            MessageType type = MessageType.Info;
            String level = eventObject.getLevel().toString();
            if ("ERROR".equalsIgnoreCase(level)) type = MessageType.Error;
            else if ("WARN".equalsIgnoreCase(level)) type = MessageType.Warning;
            client.logMessage(new MessageParams(type, eventObject.getFormattedMessage()));
        }
    }
}
