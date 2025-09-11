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
	
	all s: Student, p:Project, c1,c2:Course | c1->p in Project and c2->p in Project and s->c1 in enrolled and s->c2 in enrolled
  and s->p in projects implies c1=c2
}

