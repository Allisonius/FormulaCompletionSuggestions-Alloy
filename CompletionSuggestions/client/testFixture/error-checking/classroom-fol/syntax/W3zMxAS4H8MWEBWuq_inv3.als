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

pred inv3{
  all w : Person | in Student implies w not in Teacher
  all w : Person | in Teacher implies w not in Student
}

