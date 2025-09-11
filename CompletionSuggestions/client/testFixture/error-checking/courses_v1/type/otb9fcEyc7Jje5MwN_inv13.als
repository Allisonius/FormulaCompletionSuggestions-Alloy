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
	
	all s: Student, c: Course, g: Grade, proj: Project | s->g in c.grades.last and proj in c.projects implies proj in s.projects  
}

