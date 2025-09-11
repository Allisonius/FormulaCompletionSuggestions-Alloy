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
	
	all p1, p2:Project, all s1, s2: Student | p1 in s1.projects && p1 in s2.projects && p2 in s1.projects && p2 in s2.projects => p1=p2
}

