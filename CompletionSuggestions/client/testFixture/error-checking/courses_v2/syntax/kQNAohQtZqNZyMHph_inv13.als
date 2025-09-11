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
	
	all s : Student | all c : s.enrolled | no p in c.projects implies some sm : Student | c in sm.enrolled and s->c.grade < sm->c.grade
}

