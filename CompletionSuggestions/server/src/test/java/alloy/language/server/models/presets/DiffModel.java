package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class DiffModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		//Names of fields/associations in classes of the model
		abstract sig FName {}

		//Names of enum values in enums of the model
		abstract sig EnumVal {}

		//Values of fields
		abstract sig Val {}

		//Parent of all classes relating fields and values
		abstract sig Obj {
			get : FName -> { Obj + Val + EnumVal }
		}

		// Concrete names of fields in cd
		one sig color extends FName {}
		one sig drives extends FName {}
		one sig of extends FName {}
		one sig drivenBy extends FName {}
		one sig worksIn extends FName {}

		// Concrete value types in model cd

		// Concrete enum values in model cd
		one sig enum_ColorKind_red extends EnumVal {}
		one sig enum_ColorKind_black extends EnumVal {}
		one sig enum_ColorKind_white extends EnumVal {}

		// Classes in model cd
		sig Employee extends Obj {}
		sig Address extends Obj {}
		sig Car extends Obj {}
		sig Driver extends Obj {}

		sig Manager extends Obj {}
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("abstract sig FName {}")
		       .withContent("abstract sig EnumVal {}")
		       .withContent("abstract sig Val {}")
		       .withContent("abstract sig Obj {")
		       .withContent("    get : FName -> { Obj + Val + EnumVal }")
		       .withContent("}")
		       .withContent("one sig color extends FName {}")
		       .withContent("one sig drives extends FName {}")
		       .withContent("one sig of extends FName {}")
		       .withContent("one sig drivenBy extends FName {}")
		       .withContent("one sig worksIn extends FName {}")
		       .withContent("one sig enum_ColorKind_red extends EnumVal {}")
		       .withContent("one sig enum_ColorKind_black extends EnumVal {}")
		       .withContent("one sig enum_ColorKind_white extends EnumVal {}")
		       .withContent("sig Employee extends Obj {}")
		       .withContent("sig Address extends Obj {}")
		       .withContent("sig Car extends Obj {}")
		       .withContent("sig Driver extends Obj {}")
		       .withContent("sig Manager extends Obj {}");
		return builder;
	}
}
