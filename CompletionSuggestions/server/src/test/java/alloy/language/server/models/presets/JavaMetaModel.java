package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class JavaMetaModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		module javametamodel_withfield

abstract sig Id {}

sig Package{}

sig ClassId, MethodId,FieldId extends Id {}

abstract sig Accessibility {}

one sig public, private_, protected extends Accessibility {}

abstract sig Type {}

abstract sig PrimitiveType extends Type {}

one sig Int_, Long_ extends PrimitiveType {}

sig Class extends Type {
	package: one Package,
	id: one ClassId,
	extend: lone Class,
	methods: set Method,
	fields: set Field
}


sig Field {
    id : one FieldId,
    type: one Type,
    acc : lone Accessibility
}

sig Method {
	id : one MethodId,
    param: lone Type,
    acc: lone Accessibility,
    return: one Type,
    b: one Body
}

abstract sig Body {}

sig LiteralValue extends Body {} // returns a random value

abstract sig Qualifier {}

one sig qthis_, this_, super_ extends Qualifier {}


sig MethodInvocation extends Body {
    id : one MethodId,
    q: lone Qualifier
}

//        return new A().k();
sig ConstructorMethodInvocation extends Body {
    idClass : one ClassId,
    idMethod: one MethodId
}

//        return x;
//        return this.x;
//        return super.x;
//        return A.this.x; -> implement in Java whether use this or qualified this
sig FieldInvocation extends Body {
    idField : one FieldId,
    qField: lone Qualifier
}

//        return new A().x;
sig ConstructorFieldInvocation extends Body {
    idClass2 : one ClassId,
    idField: one FieldId
}

		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("module javametamodel_withfield")
				.withContent("abstract sig Id {}")
				.withContent("sig Package{} ")
				.withContent("sig ClassId, MethodId,FieldId extends Id {}")
				.withContent("abstract sig Accessibility {}")
				.withContent("one sig public, private_, protected extends Accessibility {}")
				.withContent("abstract sig Type {}")
				.withContent("abstract sig PrimitiveType extends Type {}")
				.withContent("one sig Int_, Long_ extends PrimitiveType {}")
				.withContent("sig Class extends Type {")
				.withContent("	package: one Package,")
				.withContent("	id: one ClassId,")
				.withContent("	extend: lone Class,")
				.withContent("	methods: set Method,")
				.withContent("	fields: set Field")
				.withContent("} ")
				.withContent("sig Field {")
				.withContent("    id : one FieldId,")
				.withContent("    type: one Type,")
				.withContent("    acc : lone Accessibility ")
				.withContent("}")
				.withContent("sig Method {")
				.withContent("	id : one MethodId,")
				.withContent("    param: lone Type,")
				.withContent("    acc: lone Accessibility,")
				.withContent("    return: one Type, ")
				.withContent("    b: one Body")
				.withContent("} ")
				.withContent("abstract sig Body {}")
				.withContent("sig LiteralValue extends Body {}")
				.withContent("abstract sig Qualifier {}")
				.withContent("one sig qthis_, this_, super_ extends Qualifier {}")
				.withContent("sig MethodInvocation extends Body {")
				.withContent("    id : one MethodId,")
				.withContent("    q: lone Qualifier ")
				.withContent("}")
				.withContent("sig ConstructorMethodInvocation extends Body {")
				.withContent("    idClass : one ClassId,")
				.withContent("    idMethod: one MethodId")
				.withContent("}")
				.withContent("sig FieldInvocation extends Body {")
				.withContent("    idField : one FieldId,")
				.withContent("    qField: lone Qualifier")
				.withContent("}")
				.withContent("sig ConstructorFieldInvocation extends Body {")
				.withContent("    idClass2 : one ClassId,")
				.withContent("    idField: one FieldId")
				.withContent("}");
		return builder;
	}
}
