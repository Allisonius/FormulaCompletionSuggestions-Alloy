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
	
	all s1:Student, s2:Student, p1:Project, p2:Project | (p1 in s.projects and p2 in s.projects and s1!=s2 and p1!=p2) implies (s1 not p2.projects and s2 not in p1.projects)
}

