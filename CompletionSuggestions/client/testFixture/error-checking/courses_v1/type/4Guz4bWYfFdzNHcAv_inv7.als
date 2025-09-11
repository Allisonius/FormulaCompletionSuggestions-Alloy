open util/ordering[Grade]

sig Person {
	teaches : set Course,
	enrolled : set Course,
	projects : set Project
}

sig Professor,Student in Person {}

sig Course {
	projects : set Project,
	grades : Person -> Grade
}

sig Project {}

sig Grade {}

pred inv7{
  
  all p1,p2:Project | all s:Student | s->p1 in Person <: projects and s->p2 in Person <: projects implies (all c1,c2:Course | c1 -> p1 and c2 -> p2 implies c1 != c2) 
}

