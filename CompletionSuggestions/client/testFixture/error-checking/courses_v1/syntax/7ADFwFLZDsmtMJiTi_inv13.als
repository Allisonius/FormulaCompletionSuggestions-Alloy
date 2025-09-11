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
	
	all s1: Student | all c1: Course | c1->s1 in grades.last implies (some p1: Project | c1->p1 in projects and s1->p1 in projects
}

