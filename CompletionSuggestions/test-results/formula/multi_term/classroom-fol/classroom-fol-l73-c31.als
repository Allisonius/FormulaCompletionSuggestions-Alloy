sig Person  {
	Tutors : set Person,
	Teaches : set Class
}

sig Group {}

sig Class  {
	Groups : Person -> Group
}

sig Teacher extends Person {}

sig Student in Person {}

pred inv1 {
	all p: Person | p in Student
}

pred inv2 {
	all p: Person | p not in Teacher
}

pred inv3 {
	all p: Person | p in Student implies p not in Teacher
}

pred inv4 {
	all p: Person | p in Student or p in Teacher
}

pred inv5 {
	some Teacher.Teaches
}

pred inv6 {
	all t: Teacher | some c:Class | t -> c in Teaches
}

pred inv7 {
	all c: Class | some Teacher & Teaches.c
}

pred inv8 {
	all t: Teacher, c1,c2: Class | t -> c1 in Teaches and t -> c2 in Teaches => c1 = c2
}

pred inv9 {
	all c: Class | lone Teacher & Teaches.c
}

pred inv10 {
	all c: Class, s: Student | some g: Group | c -> s -> g in Groups
}

pred inv11 {
	all c: Class | some c.Groups implies some Teacher & Teaches.c
}

pred inv12 {
	all x: Teacher | some x.Teaches.Groups
}

pred inv13 {
	Tutors in Teacher -> Student
}

pred inv14 {
	all c: Class, p: Person | p in (c.Groups).Group implies Teaches.c -> p in Tutors
}

pred inv15 {
	all p:Person | some Teacher & 
}
