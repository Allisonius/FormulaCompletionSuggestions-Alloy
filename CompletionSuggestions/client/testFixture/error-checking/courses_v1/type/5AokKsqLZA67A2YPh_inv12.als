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

pred inv12{
	
  	
	
  	all g1,g2 : Grade | all s : Student | all c : Course | g1+g2 in s.c.grades implies g1=g2
}

