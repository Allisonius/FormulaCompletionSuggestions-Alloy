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
	
  	all s : Student, c : Course, p1, p2 : Project | s->c in enrolled and 
  s->p1 in Person<:projects and 
  c->p1 in Course<:projects and 
  s->p2 in Person<:projects and 
  c->p2 in Course<:projects implies p1 = p2

