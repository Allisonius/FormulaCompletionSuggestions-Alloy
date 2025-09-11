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
	all p:Person |some g:Group | all t:Teacher | t-> Groups.(p,g) in Teaches 
}

