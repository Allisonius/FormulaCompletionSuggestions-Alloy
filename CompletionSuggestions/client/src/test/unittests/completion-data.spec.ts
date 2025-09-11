import {
  generateCompletionSnippets,
  getCompletionOffsets,
} from "../../utilities/completion-snippet";
import * as assert from "assert";

const COMPLETION_TERMS = [" in ", "."];

describe("Text should be splitted into proper snippets", () => {
  //prettier-ignore
  const text = 
`sig Person {}
sig Student in Person {}
sig Teacher in Person {
    teaches: set Student
}
pred p1 {
    some Teacher.teaches
}
`;
  const completionSnippets = generateCompletionSnippets(text, COMPLETION_TERMS);
  it("should make correct number of snippets", () => {
    assert(
      completionSnippets.length == 4,
      `Not expected number of snippets ${completionSnippets.length}`
    );
  });

  it("should have correct breaking terms", () => {
    assert(completionSnippets[0].completionTerm == " in ", "Snippet 1");
    assert(completionSnippets[1].completionTerm == " in ", "Snippet 2");
    assert(completionSnippets[2].completionTerm == ".", "Snippet 3");
    assert(completionSnippets[3].completionTerm == "", "Snippet 4");
  });

  it("should output input text correctly when joined", () => {
    const joinedText = completionSnippets
      .map((snippet) => snippet.snippet + snippet.completionTerm)
      .join("");
    assert(joinedText == text, "Joined text is not equal to input text");
  });
});

describe("getCompletionOffsets for a text", () => {
  //prettier-ignore
  const text = 
`12 4 in 9.10`;
  const offsets = getCompletionOffsets(text, COMPLETION_TERMS);
  console.log("Offsets: ", offsets);
  it("should have correct number of offsets", () => {
    assert(
      offsets.length == 2,
      `Not expected number of offsets ${offsets.length}`
    );
  });

  it("should have correct offset numbers", () => {
    assert(offsets[0] == 8, "Offset 1");
    assert(offsets[1] == 10, "Offset 2");
  });
});

describe("getCompletionOffsets for a text with initial offset", () => {
  //prettier-ignore
  const text = 
`12 4 in 9.10`;
  const offsets = getCompletionOffsets(text, COMPLETION_TERMS, 8);
  console.log("Offsets: ", offsets);
  it("should have correct number of offsets", () => {
    assert(
      offsets.length == 1,
      `Not expected number of offsets ${offsets.length}`
    );
  });

  it("should have correct offset numbers", () => {
    assert(offsets[0] == 10, "Offset 1");
  });
});
