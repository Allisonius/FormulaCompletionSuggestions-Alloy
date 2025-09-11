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

pred inv5{
  all t : Teacher| aaa[t]
}

pred aaa[t:Teacher]{
  some c: Class | t->c
}

