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

pred inv8{
  
  
  all p:Person | some c: Class | t -> c in Teaches
  Teacher <:Teaches in Teacher -> one Class
}

