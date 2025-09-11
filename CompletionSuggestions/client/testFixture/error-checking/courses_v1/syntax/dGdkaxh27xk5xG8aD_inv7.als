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
	
	
  all s : Student | all p1,p2 : Projects | all c : Course | (c->p1 in projects and s->p1 in projects) and  (c->p2 in projects and s->p2 in projects) implies p1=p2
 }

