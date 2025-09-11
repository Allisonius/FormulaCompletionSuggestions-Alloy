package alloy.language.server.utils;

import alloy.language.server.models.CompletionModelBuilder;
import alloy.language.server.models.presets.CourseModel;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CodeUtilsTest {

	@Test
	void getCuratedTextAfterRemovingLinesInRange() {
		CompletionModelBuilder builder = CourseModel.modelBuilder();
		String content = builder.withContent("pred p1 {").withCompletionLine("all p : Person, c: Course | some p.projects in c.").withContent("some Person").withContent("}").build();
		System.out.println(content);
		String curatedText = CodeUtils.getCuratedTextAfterRemovingLinesInRange(content, 14, 15);
		System.out.println("Curated Text: ");
		System.out.println(curatedText);
	}
}