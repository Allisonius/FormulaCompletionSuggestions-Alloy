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
	all x : Class | some p: Person, g : Groups | x->p->g in Groups implies some t : Teacher | p->g in Teaches 
}

