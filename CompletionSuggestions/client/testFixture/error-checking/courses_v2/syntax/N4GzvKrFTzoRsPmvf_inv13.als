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
	
	all s: Student | all c:Course| all g1: Grade|
  	c->s->g in grades and  g in c.grades.last => some p:Project | s->p in projects and c->p in projects
}

