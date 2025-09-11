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

pred inv13{
	
	all c1 : Course | all s1 : Student |
	(s1->c1 in enrolled and (max[g1:Grade|c1->s1->g1])) 
  	implies (some p1 : Project|c1->p1 in projects and s1->p1 in projects)
}

