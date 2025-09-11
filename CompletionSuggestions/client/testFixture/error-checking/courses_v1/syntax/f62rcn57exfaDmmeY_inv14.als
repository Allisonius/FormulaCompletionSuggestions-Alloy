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
	
	all s1, s2 : Student, p : Project | (p in s1.projects and p in s2.projects) => all p1 : (Project - p) | p1 not in s1.projects or p2 not in s2.projects 
}

