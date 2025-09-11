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
	
  	
  	all x : Student | all c :  Course | some y, z : Project | y -> x in c.projects and z -> x in c.projects implies y = z
  
}

