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

pred inv9{
	no c:Class | all p1,p2:Teacher | c in p1->Teaches and c in p2->Teaches implies p1=p2
}

