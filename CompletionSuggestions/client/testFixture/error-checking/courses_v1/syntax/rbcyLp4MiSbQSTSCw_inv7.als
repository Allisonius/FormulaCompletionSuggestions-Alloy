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
	
	all p1 : Student | all pr1 : Project | all c1 : Course | (p1->pr1 in project) and (c1->pr1 in projects)
}

