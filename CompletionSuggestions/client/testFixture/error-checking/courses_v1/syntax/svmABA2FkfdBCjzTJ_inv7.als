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
	
  	
	
	
	all s:Student, c1,c2:Course, p:Project | (s->c in enrolled and c->p in projects) implies s->p in projects
}

