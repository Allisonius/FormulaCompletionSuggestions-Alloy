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

pred inv12{
  Teacher in Class.Groups.Group
  for t: Teacher | some c: Class | c in t.Teaches implies t in c.Groups.Group
}

