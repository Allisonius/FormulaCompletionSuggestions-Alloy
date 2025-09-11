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

pred inv15{
	
	all p: Project, disj s1,s2: Student | p in s1.projects&s2.projects implies s2.(Course.grades) in s1.(Course.grades).next + s1.(Course.grades).prev + s1.(Course.grades))
}


