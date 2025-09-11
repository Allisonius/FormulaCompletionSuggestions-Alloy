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
	all s:Student,c:Class,g:Group|some t:Teacher | t->c in Teaches and some s.(c.Groups) and  t.(c.Groups)
}

