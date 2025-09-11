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
	
	all u1: User, u2: User, u3: User, proj: Project | proj in u1.projects and proj in u2.projects and proj in u3.projects implies u3 != u2
}

