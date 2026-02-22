package alloy.language.server;

import com.google.gson.GsonBuilder;
import org.apache.commons.cli.*;
import org.eclipse.lsp4j.jsonrpc.Launcher;
import org.eclipse.lsp4j.jsonrpc.MessageConsumer;
import org.slf4j.Logger;
import org.slf4j.MDC;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.nio.channels.AsynchronousServerSocketChannel;
import java.nio.channels.AsynchronousSocketChannel;
import java.nio.channels.Channels;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.function.Consumer;
import java.util.function.Function;


public class ServerApplication {

	private static final Logger logger = org.slf4j.LoggerFactory.getLogger(ServerApplication.class);

	private static final Function<MessageConsumer, MessageConsumer> wrapper = consumer -> message -> {
		ConfigManager configManager = ConfigManager.getInstance();
		if (configManager.isEnableVerbose()) {
			logger.debug("Consuming message: {}", message);
		}
		consumer.consume(message);
	};

	public static void main(String[] args) throws InterruptedException, ExecutionException, IOException, ParseException {
        // Set a unique sessionId for this server run (used in logback.xml)
        MDC.put("sessionId", UUID.randomUUID().toString());

		// create Options object
		Options options = new Options();

		// add t option
		options.addOption(new Option("m", "enable-multi-term", false, "Enable Multi-term completions"));
		options.addOption(new Option("v", "verbose", false, "Enable verbose logging"));
		options.addOption(new Option("s", "stdio", false, "Launch the server using stdio"));
		options.addOption(new Option("c", "log-to-client", false, "Send logs to the client via LanguageClient.logMessage()"));
		options.addOption(new Option("g", "use-generator", false, "Use the generator for completions"));
		options.addOption(new Option("n", "new-extractor-evaluation-completion", false, "Use the new completion provider that extracts the completion context and evaluates it to provide completions"));

		CommandLineParser parser = new DefaultParser();
		CommandLine cmd = parser.parse(options, args);

		ConfigManager configManager = ConfigManager.getInstance();
		configManager.setEnableMultiTermCompletion(cmd.hasOption("m"));
		configManager.setEnableMultiTermCompletion(true);
		configManager.setEnableVerbose(cmd.hasOption("v"));
		configManager.setLogToClient(cmd.hasOption("c"));
		configManager.setUseGeneratorCompletion(cmd.hasOption("g"));
//		configManager.setUseGeneratorCompletion(true);
//		configManager.setUseNewCompletionProvider(cmd.hasOption("n"));
		configManager.setUseNewCompletionProvider(true);

        logger.info("Multi-term completion: {}", configManager.isEnableMultiTermCompletion());

//		LogManager.getLogManager().reset();
//		Logger globalLogger = Logger.getLogger(java.util.logging.Logger.GLOBAL_LOGGER_NAME);
//		globalLogger.setLevel(java.util.logging.Level.OFF);
//		// Dynamically configure Logback appenders based on logToClient flag
//		if (!configManager.isLogToClient()) {
//			ch.qos.logback.classic.Logger rootLogger =
//				(ch.qos.logback.classic.Logger) org.slf4j.LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME);
//			rootLogger.detachAppender("CLIENT");
//		}
		if (cmd.hasOption("s")) {
			logger.info("Starting stdio server");
			startStdioLauncher();
		} else {
			logger.info("Starting socket server");
			startSocketLauncher();
		}
	}

	public static void startSocketLauncher() throws InterruptedException, ExecutionException, IOException {
		AlloyLanguageServer server = new AlloyLanguageServer();
		Consumer<GsonBuilder> gsonBuilderConsumer = GsonBuilder::setPrettyPrinting;
		Launcher<AlloyLanguageClient> launcher =
				createSocketLauncher(server, AlloyLanguageClient.class, new InetSocketAddress("localhost", 5007),
				                     Executors.newCachedThreadPool(), wrapper, gsonBuilderConsumer);
		server.connect(launcher.getRemoteProxy());
		Future<?> future = launcher.startListening();
		while (!future.isDone()) {
			Thread.sleep(10_000l);
		}
	}

	public static void startSocketLauncherForMultipleClients() throws IOException {
		AlloyLanguageServer server = new AlloyLanguageServer();
		Consumer<GsonBuilder> gsonBuilderConsumer = GsonBuilder::setPrettyPrinting;
		AsynchronousServerSocketChannel serverSocket = AsynchronousServerSocketChannel.open().bind(new InetSocketAddress("localhost", 5007));
		ExecutorService executor = Executors.newCachedThreadPool();

		logger.info("Socket server listening on port 5007");

		// Accept clients in a loop
		while (true) {
			try {
				AsynchronousSocketChannel socketChannel = serverSocket.accept().get();
				executor.submit(() -> {
					try {
						Launcher<AlloyLanguageClient> launcher = Launcher.createIoLauncher(
								server,
								AlloyLanguageClient.class,
								Channels.newInputStream(socketChannel),
								Channels.newOutputStream(socketChannel),
								executor,
								wrapper,
								gsonBuilderConsumer
						);
						AlloyLanguageClient client = launcher.getRemoteProxy();
						server.connect(client);
						launcher.startListening().get();
					} catch (Exception e) {
						e.printStackTrace();
					}
				});
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private static <T> Launcher<T> createSocketLauncher(Object localService,
	                                                    Class<T> remoteInterface,
	                                                    SocketAddress socketAddress,
	                                                    ExecutorService executorService,
	                                                    Function<MessageConsumer, MessageConsumer> wrapper,
	                                                    Consumer<GsonBuilder> gsonConfig) throws IOException {
		AsynchronousServerSocketChannel serverSocket = AsynchronousServerSocketChannel.open().bind(socketAddress);
		AsynchronousSocketChannel socketChannel;
		try {
			socketChannel = serverSocket.accept().get();
			return Launcher.createIoLauncher(localService, remoteInterface, Channels.newInputStream(socketChannel),
			                                 Channels.newOutputStream(socketChannel), executorService, wrapper,
			                                 gsonConfig);
		} catch (InterruptedException | ExecutionException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void startStdioLauncher() {
		try {
			AlloyLanguageServer server = new AlloyLanguageServer();
			// Create the launcher with proper error handling
			Launcher<AlloyLanguageClient> launcher = new Launcher.Builder<AlloyLanguageClient>().setLocalService(server)
			                                                                                    .setRemoteInterface(AlloyLanguageClient.class)
			                                                                                    .setInput(System.in)
			                                                                                    .setOutput(System.out)
			                                                                                    .setExecutorService(Executors.newCachedThreadPool())
			                                                                                    .wrapMessages(wrapper)
			                                                                                    .create();

			AlloyLanguageClient client = launcher.getRemoteProxy();
			server.connect(client);

			launcher.startListening().get();
		} catch (Exception e) {
			System.err.println("Error starting stdio server:");
			e.printStackTrace(System.err);
			System.exit(1);
		}
	}
}
