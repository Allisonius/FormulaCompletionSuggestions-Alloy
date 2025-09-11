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

pred inv10{
	
   all c : Class | all p: Person | all g : Groups  | p in Student and g in c.Groups implies p->g in c.Groups 
  
}

