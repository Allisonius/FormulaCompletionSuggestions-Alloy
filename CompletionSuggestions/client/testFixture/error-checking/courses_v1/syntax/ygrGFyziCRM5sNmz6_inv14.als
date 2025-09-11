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

pred inv14{
	
	all s1:Student,s2:Student, p1:Project | s1->p1 in projects and s2->p1 in projects implies all p2:Projects | (s1->p2 in projects implies s2->p2 not in projects) and (s2->p2 in projects implies s1->p2 not in projects)
}

