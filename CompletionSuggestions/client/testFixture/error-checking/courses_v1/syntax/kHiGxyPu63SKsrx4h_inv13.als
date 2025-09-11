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
	
  
  
  all c : Course, s : enrolled.c | (some c.grades.s and all x->g : c.grades | ordering/gte[c.grades.s,g]) implies c in projects.(s.projects) 

}

