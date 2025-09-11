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
	
	all c: Course | some s1: Student | all s2: Student, g: Grade | some p: Project| s1->g > s2->g implies some(s.projects & c.projects)
}

