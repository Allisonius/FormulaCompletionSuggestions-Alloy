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
	
	s2 in Student and p in Project and s1->p in Person <: projects and s2->p in Person <: projects implies all p1 : Project | p1!=p and s1->p1 in Person <: projects implies not s2->p1 in Person <: projects
}

