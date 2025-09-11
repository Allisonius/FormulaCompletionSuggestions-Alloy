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

pred inv10{
  ~Groups.Groups in iden and ~(Student<:Class.Groups).(Student<:Class.Groups) in iden
}

