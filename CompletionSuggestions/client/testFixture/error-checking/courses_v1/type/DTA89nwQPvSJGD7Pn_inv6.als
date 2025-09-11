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
	
  all s: Student| some p: Project | s->p in Course <: projects implies (some c: Course| p->c in Course <: projects and s->c in enrolled)



}

