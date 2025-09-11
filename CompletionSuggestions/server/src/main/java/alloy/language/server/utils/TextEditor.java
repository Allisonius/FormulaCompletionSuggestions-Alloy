package alloy.language.server.utils;

import org.eclipse.lsp4j.Range;

public class TextEditor {
	private final String text;

	public TextEditor(String text) {
		this.text = text;
	}

	public String getOriginalText() {
		return text;
	}

	public String getLine(int lineNumber) {
		String[] lines = text.split("\n");
		if (lineNumber < 0 || lineNumber >= lines.length) {
			throw new IndexOutOfBoundsException("Line number out of range: " + lineNumber);
		}
		return lines[lineNumber];
	}

	public String getLineUntilCharacterPosition(int lineNumber, int characterPosition) {
		String line = getLine(lineNumber - 1); // Convert to 0-based index
		if (characterPosition < 0 || characterPosition > line.length()) {
			throw new IndexOutOfBoundsException("Character position out of range: " + characterPosition);
		}
		return line.substring(0, characterPosition).trim();
	}

	/**
	 * Replaces the text in the specified range with whitespace, retaining the newlines.
	 * If the start position of the range exceeds the length of a line, it will not modify that line.
	 * If the end position of the range exceeds the length of a line, it will modify until the end of the line.
	 * @param range The range to be whitewashed.
	 * @return The modified text with the specified range replaced by whitespace.
	 */
	public String getWhiteWashedText(Range range) {
		String[] lines = text.split("\n");
		int startLine = range.getStart().getLine() - 1; // Convert to 0-based index
		int endLine = range.getEnd().getLine() - 1; // Convert to 0-based index

		if (startLine < 0 || endLine >= lines.length || startLine > endLine) {
			throw new IndexOutOfBoundsException("Invalid range for whitewashing: " + range);
		}

		StringBuilder modifiedText = new StringBuilder();
		for (int i = 0; i < lines.length; i++) {
			if (i < startLine || i > endLine) {
				modifiedText.append(lines[i]);
			} else {
				int startChar = (i == startLine) ? Math.min(range.getStart().getCharacter(), lines[i].length()) : 0;
				int endChar;
				if (i == endLine) {
					int endCharValue = range.getEnd().getCharacter();
					endChar = (endCharValue == -1) ? lines[i].length() : Math.min(endCharValue, lines[i].length());
				} else {
					endChar = lines[i].length();
				}
				modifiedText.append(lines[i], 0, startChar)
				            .append(" ".repeat(Math.max(0, endChar - startChar)))
				            .append(lines[i].substring(endChar));
			}
			modifiedText.append("\n");
		}
		return modifiedText.toString().trim();
	}

	/**
	 * Returns the text from the specified range, inclusive of the start and end positions.
	 * @param range The range to extract text from.
	 * @return The text within the specified range.
	 */
	public String getTextInRange(Range range) {
		String[] lines = text.split("\n");
		int startLine = range.getStart().getLine() - 1; // Convert to 0-based index
		int endLine = range.getEnd().getLine() - 1; // Convert to 0-based index

		if (startLine < 0 || endLine >= lines.length || startLine > endLine) {
			throw new IndexOutOfBoundsException("Invalid range for text extraction: " + range);
		}

		StringBuilder extractedText = new StringBuilder();
		for (int i = startLine; i <= endLine; i++) {
			if (i == startLine) {
				extractedText.append(lines[i], range.getStart().getCharacter(), lines[i].length());
			} else if (i == endLine) {
				extractedText.append(lines[i], 0, range.getEnd().getCharacter());
			} else {
				extractedText.append(lines[i]);
			}
			if (i < endLine) {
				extractedText.append("\n");
			}
		}
		return extractedText.toString();
	}
}
