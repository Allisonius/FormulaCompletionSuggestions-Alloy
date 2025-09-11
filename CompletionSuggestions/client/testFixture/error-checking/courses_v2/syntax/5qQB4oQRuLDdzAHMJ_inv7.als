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
	
	all s:Student | all c1,c2:Course | s->c1 in enrolled and s->c2 in enrolled implies (some pr:Project | s->c in projects and c1 = c2 )
}

