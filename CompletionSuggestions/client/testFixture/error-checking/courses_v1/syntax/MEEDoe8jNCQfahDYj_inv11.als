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

pred inv11{
	
	all s1: Student | all c1: Course | all g1: grade | (c1->s1->g1 in grades) implies s1->c1 in enrolled
}

