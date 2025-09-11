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
	
  	all s : Student | all c : Course | all g : Grade | all p: c.projects&s.projects | (s->g) in max.c.grades implies #p=1
}

