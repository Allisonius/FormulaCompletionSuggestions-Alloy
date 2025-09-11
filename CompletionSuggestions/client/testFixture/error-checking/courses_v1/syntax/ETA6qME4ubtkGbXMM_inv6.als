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

pred inv6{
	
	all s,p : univ | s in Student and p in Project s->p in Person <: projects implies some c : Course | s->c in enrolled and c->p in Course <: projects 

}

