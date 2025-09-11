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

pred inv7{
	
 	all s: Student, c: Course, p1: Project, P2: Project | c in s.(Person <: enrolled) and p1 in s.(Person <: projects) and p2 in s.(Person <: projects) implies (p1 in c.(Course <: projects) and p2 not in c.(Course <: projects)) or (p2 in c.(Course <: projects) and p1 not in c.(Course <: projects))
}

