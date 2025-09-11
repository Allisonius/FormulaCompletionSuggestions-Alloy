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
	
  	all s,p,c : univ | s in Student and p In Project and c in Course and s->p in projects and c->p in projects implies all p1,p2 : univ | p1 in Project and p2 in Project and s->p1 in projects and s->p2 in projects implies p1=p2
}

