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
	
	all u1: Person, u2: Person, proj1: Project, proj2: Project | u1->proj1 in projects and u2->proj1 and u1->proj2 in projects and u2->proj2 in projects implies proj1 = proj2
}

