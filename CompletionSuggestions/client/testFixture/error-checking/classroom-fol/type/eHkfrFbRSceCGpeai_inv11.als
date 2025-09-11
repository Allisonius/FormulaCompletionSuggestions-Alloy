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

  	all c:Class | (some g:Group |some p:Person | c->(p->g))  implies (some t:Teacher | t->c in Teaches )
  
}

