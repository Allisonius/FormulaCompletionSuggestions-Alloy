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
  some c:Class ,g:Groups ,t:Teacher| all s :Student | (c->(s->g) in Groups  and t->c in Teaches) 

}

