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

pred inv13{
	
	all c: Course, s: Student, g: Grade | s->g in c.grades && g = max(c.grades) => some p: Project | p in project.c && p in s.projects
}

