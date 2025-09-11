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
	all c:Class|some t:Teacher, g:Group | t->c in Tutor implies c->t->g in Groups
  	

}

