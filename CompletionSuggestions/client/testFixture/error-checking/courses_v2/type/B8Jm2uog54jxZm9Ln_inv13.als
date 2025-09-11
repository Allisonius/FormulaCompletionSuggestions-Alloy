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
	
  all x : Student, g : Grade | all p : x.projects | all c : Course | x->g in c.grades and x->g = max(c.grades) implies p in c.projects
  
}

