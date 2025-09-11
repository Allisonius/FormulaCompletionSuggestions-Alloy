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
	all c : Class { 
      all s : Student | s->Group in c.Groups {
        all t : Teacher | c in t.Teaches {
          s in t.Tutors
        }
      }
    }
}

