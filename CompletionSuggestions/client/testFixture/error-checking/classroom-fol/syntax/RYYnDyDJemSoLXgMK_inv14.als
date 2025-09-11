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
 	(all s :Student | some c:Class | some g:Group | c->s->g in Groups) and (some t:Teacher| t->c in Teaches implies t->s in Tutors)
  
  

}

