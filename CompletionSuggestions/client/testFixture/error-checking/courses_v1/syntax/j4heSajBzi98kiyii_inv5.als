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
	
	
	all c: Course | all s: Person | all g: Grade | c->s->g in grades => s in Student
  
	all c: Course | all s: Person | some g: Grade | all p:Project | c->p in project => some(c->s->g in grades)
  
}

