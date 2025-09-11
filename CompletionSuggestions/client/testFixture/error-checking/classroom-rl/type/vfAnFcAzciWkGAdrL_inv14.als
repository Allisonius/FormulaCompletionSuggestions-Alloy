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
	some Student in Class.(Groups.Student) and Class in (Teacher<:Teaches).Class implies Student in (Teacher<:Tutors).Student 
}

