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
	all s : Student | some t : Teacher, c : class | all  g : Group | 
  		(c -> t -> g in Groups and t -> c in Teaches) and t -> s in Tutors     
}

