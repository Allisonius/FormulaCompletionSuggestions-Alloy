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
	
	all c: Course, g1, g2: Grade, p: Project, disj s1, s2:Student | s1->p+s2->p in projects && c->s1->g1+c->s2->g2 in grades => not smaller[g1,g2]
}


