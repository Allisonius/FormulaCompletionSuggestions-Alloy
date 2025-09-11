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
	
	all s1 : Student | all s2 : Student - s1 | all c : Course | (one c.projects & s1.projects & s2.projects) implies (all g1 : Grade | all g2 : Grade | s1->g1 in c.grades and s2->g2 in c.grades implies g2-g1<=1) 
}

