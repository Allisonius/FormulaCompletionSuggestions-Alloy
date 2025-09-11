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
	
	all s:Student,c:Course,g:Grade| one g1:Grade | c->s->g1 in grades and c->s->g in grades and (g1 >= g) implies (one p:Project | c->p in projects and s->p in projects)
}

