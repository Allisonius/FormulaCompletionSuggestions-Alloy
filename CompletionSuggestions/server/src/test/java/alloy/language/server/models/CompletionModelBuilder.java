package alloy.language.server.models;

public class CompletionModelBuilder {

	private StringBuilder builder;
	private int completionLine = -1;
	private int completionCharacter = -1;

	private CompletionModelBuilder() {
		builder = new StringBuilder();
	}

	public static CompletionModelBuilder modelBuilder() {
		return new CompletionModelBuilder();
	}

	public String build() {
		builder.append("\n");
		builder.append("run {} for 3").append("\n");
		return builder.toString();
	}

	public String buildWithoutCommand() {
		return builder.toString();
	}

	public int getCompletionLineNumber() {
		return completionLine;
	}

	public int getCompletionCharacterNumber() {
		return completionCharacter;
	}

	public CompletionModelBuilder withContent(String content) {
		builder.append(content).append("\n");
		return this;
	}

	public CompletionModelBuilder withCompletionLine(String line) {
		builder.append(line).append("\n");
		completionLine = builder.toString().split("\n").length - 1;
		completionCharacter = line.length();
		return this;
	}
}
