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

pred inv11{
 	 all c:Class | all g:Groups| some c.g iff some t:Teacher | c in t.Teaches
}

