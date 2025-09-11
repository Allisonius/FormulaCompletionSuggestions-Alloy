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
	
all c: Course, p: Project, s1: Student, s2: Student, g: Grade | p in s1.projects && p in s2.projects => s1 -> c.grades s1 = s2 -> c.grades
}


