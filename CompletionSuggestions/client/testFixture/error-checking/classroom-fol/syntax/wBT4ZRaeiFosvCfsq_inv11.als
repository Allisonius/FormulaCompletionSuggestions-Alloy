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
 
  
  
  all c.Class | some t:Teacher | some c.Groups implies c in t.Teaches
}

