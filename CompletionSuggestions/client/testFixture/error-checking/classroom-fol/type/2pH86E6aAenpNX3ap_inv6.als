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

pred inv6{
	all p:Person,c:Class,g:Group | p in Teacher implies c->p->g in Class
}

