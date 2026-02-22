module javametamodel_withfield
// ABSTRACT SYNTAX

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

sig LiteralValue extends 

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
