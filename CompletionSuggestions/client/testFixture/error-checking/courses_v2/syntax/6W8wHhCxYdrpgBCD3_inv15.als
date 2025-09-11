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
	
all c: Course, p1, p2: Project | p1 in c.projects && p2 in c.projects && p1 != p2 => all s1: Student, s2: Student | s1 in p1.projects && s2 in p2.projects => c.grades[s1] = c.grades[s2])
}


