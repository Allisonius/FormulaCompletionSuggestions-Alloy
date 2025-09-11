sig Person  {
	Tutors : set Person,
	Teaches : set Class
}
sig Group {}

sig Class  {
	Groups : Person -> Group
}

sig Teacher in Person  {}

sig Student in Person  {}

pred inv14{
	all c: Class | let w = Tutors.(c.Groups.Group & Student) | no w or Teaches.c in w
}

