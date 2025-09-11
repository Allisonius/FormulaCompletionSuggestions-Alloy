interface CompletionSnippet {
  snippet: string;
  completionTerm: string;
}

export function generateCompletionSnippets(
  text: string,
  completionTerms: string[]
): CompletionSnippet[] {
  const snippets: CompletionSnippet[] = [];
  let snippetStart = 0;

  for (let i = 0; i < text.length; i++) {
    for (const term of completionTerms) {
      const termLength = term.length;

      // Check if the current substring matches the term
      if (text.substring(i, i + termLength) === term) {
        // Add the snippet up to the current index
        const snippet = text.substring(snippetStart, i);
        if (snippet) {
          snippets.push({ snippet, completionTerm: term });
        }

        // Update the start of the next snippet
        snippetStart = i + termLength;

        // Skip ahead to the end of the term
        i += termLength - 1;
      }
    }
  }

  // Add the last snippet
  const lastSnippet = text.substring(snippetStart);
  if (lastSnippet) {
    snippets.push({ snippet: lastSnippet, completionTerm: "" });
  }

  return snippets;
}

export function getCompletionOffsets(
  text: String,
  completionTerms: string[],
  initialOffset = 0
): number[] {
  const offsets: number[] = [];
  for (let i = initialOffset; i < text.length; i++) {
    for (const term of completionTerms) {
      const termLength = term.length;
      if (text.substring(i, i + termLength) === term) {
        offsets.push(i + termLength);
        i += termLength;
      }
    }
  }
  return offsets;
}
