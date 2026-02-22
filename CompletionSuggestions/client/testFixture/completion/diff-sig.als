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