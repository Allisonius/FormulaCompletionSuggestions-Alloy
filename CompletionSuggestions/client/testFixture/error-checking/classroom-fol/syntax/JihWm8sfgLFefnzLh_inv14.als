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
  all p:Person,c:Class,t:Teacher | (some g:Group | c->p->g in Groups) and t->c in Teaches) implies 
}

