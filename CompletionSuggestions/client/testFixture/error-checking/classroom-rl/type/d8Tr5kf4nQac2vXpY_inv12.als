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
	all t:Teacher | some t.Teaches in Class  and  some g:Group, p:Person | t.Teaches->p->g in Groups 

}

