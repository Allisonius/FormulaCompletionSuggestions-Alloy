sig Person  {
	Tutors : set Person,
	Teaches : set Class
}
 
sig Group {}
 
sig Class  {
	Groups : Person -> Group
}
 
sig Teacher extends Person  {}
 
sig Student in Person  {}
 
pred inv1 { 
	Person in Student
}

pred inv2 { 
	no Teacher
}

pred inv3 { 
	no Student & Teacher
}

pred inv4 { 
	Person in Student + Teacher
}

pred inv5 { 
	some Teacher.Teaches
}

pred inv6 { 
	all t : Teacher | some t.Teaches
}

pred inv7 { 
	Class in Teacher.Teaches
}

pred inv8 { 
	all t : Teacher | lone t.Teaches
}

pred inv9 {
	all c : Class | lone Teaches.c & Teacher
}

pred inv10 { 
	all c : Class, s : Student | some s.(c.Groups)
}

pred inv11 {
	all c : Class | some c.Groups implies some Teaches.c & Teacher
}

pred inv12 { 
	all x : Teacher | some x.Teaches.Groups
}

pred inv13 { 
	Tutors in Teacher -> Student
}

pred inv14 {
	all p : Person, c : Class | some p.(c.Groups) implies Teaches.c in 
}

pred inv15 {
	all p : Person | some ^Tutors.p & Teacher
}
