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
	
all c: Course, s: Student, g: Grade | s->g in c.grades && (not (exists g2 : Grade | s->g2 in c.grades && g2 > g)) => some p: Project | p in c.projects && p in s.projects
}

