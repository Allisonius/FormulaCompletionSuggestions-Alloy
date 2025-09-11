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
	all g:Group | some c:Class,some t:Teacher | t->g in c.Groups and t->c in Teaches 
}

