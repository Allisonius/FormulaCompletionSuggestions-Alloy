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
	all s : Student | 
  		(some c : Class | s in c.Groups.Group) implies (
        	all t : Teaches.c :> Teacher | s in t.Tutors
        )
}

