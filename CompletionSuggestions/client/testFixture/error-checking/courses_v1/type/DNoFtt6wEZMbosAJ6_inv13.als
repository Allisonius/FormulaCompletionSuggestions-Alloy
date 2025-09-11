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
	
  	all s : Student | all g : Grade | all c : Course | all g : Grade | g = max.c.grades and s->g in c.grades implies c.projects&s.projects != none
}

