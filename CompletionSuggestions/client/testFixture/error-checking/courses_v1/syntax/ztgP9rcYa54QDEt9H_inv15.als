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

pred inv15{
	
	all s1,s2 : Student | all c1 : Course | all p1:Project|
	(c1->project in projects and s1->p1 in projects and s2->p1 in projects)
	implies
	(one g1,g2 : Grade | c1->s1->g1 in grades and c1->s2->g2 in grades and |g1-g2|<1) 
	


}


