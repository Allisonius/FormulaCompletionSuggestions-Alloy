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
	all s:Student,c:Class|some t:Teacher,g:Group | t->c in Teaches and one s.(c.Groups).g and one t.(c.Groups) implies t in s.^Tutors
}

