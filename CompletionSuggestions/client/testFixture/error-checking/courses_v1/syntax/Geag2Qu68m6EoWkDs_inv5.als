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

pred inv5{
	
	
	
    all x,y : univ | x->y in Person<:projects implies x not in Professor and x in Student
    all x : Project | implies some y : Student | y->x in Person<:projects
}

