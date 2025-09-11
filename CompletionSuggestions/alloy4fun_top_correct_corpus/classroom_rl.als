/* The registered persons. */
sig Person  {
	/* Each person tutors a set of persons. */
	Tutors : set Person,
	/* Each person teaches a set of classes. */
	Teaches : set Class
}
 
/* The registered groups. */
sig Group {}
 
/* The registered classes. */
sig Class  {
	/* Each class has a set of persons assigned to a group. */
	Groups : Person -> Group
}
 
/* Some persons are teachers. */
sig Teacher extends Person  {}
 
/* Some persons are students. */
sig Student in Person  {}
 
pred inv1 { //same as oracle
	Person in Student
}

pred inv2 { //same as oracle
	no Teacher
}

pred inv3 { //same as oracle
	no Student & Teacher
}

pred inv4 { //same as oracle
	Person in Student + Teacher
}

pred inv5 { //same as oracle
	some Teacher.Teaches
}

pred inv6 { //same as oracle
	all t:Teacher | some t.Teaches
}

pred inv7 { 
	Class in Teacher.Teaches
}

pred inv8 { //same as oracle
	all t:Teacher | lone t.Teaches
}

pred inv9 {
	all c:Class| lone Teaches.c & Teacher
}

pred inv10 { //same as oracle
	all c:Class,s:Student | some s.(c.Groups)
}

pred inv11 {
	all c:Class|some c.Groups implies some Teaches.c & Teacher
}

pred inv12 { //same as oracle
	all x:Teacher | some x.Teaches.Groups
}

pred inv13 { //same as oracle
	Tutors in Teacher -> Student
}

pred inv14 {
	all p : Person, c : Class | some p.(c.Groups) implies Teaches.c in Tutors.p
}

pred inv15 {
	all p: Person| some ^Tutors.p & Teacher
}