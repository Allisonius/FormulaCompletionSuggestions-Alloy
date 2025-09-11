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
	
 	some c:Class| somee (Teaches.c - Teacher) and  some g:Group, p:Person | c->p->g in Groups

}

