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
 	some s :Student | some c:class | some g:Group c->s->g in Groups and (some t:Teacher t->c)
  
  

}

