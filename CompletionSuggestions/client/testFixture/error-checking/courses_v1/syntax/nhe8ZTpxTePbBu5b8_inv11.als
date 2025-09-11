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

pred inv11{
	
    all s: Student, c: Course, g: Grades | s->p->g in grades implies (s->c in enrolled and c->p in projects)
}

