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

pred inv5{
	
	
	all p:Person | p in Student implies some pr in Projects | p->pr in Projects and all pr in Projects | some p:Student | p->pr in Projects
}

