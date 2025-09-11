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
	
	
	all p1 : Project | some pr1 : Student | pr1.projects.p1 
  	all p2 : Project | all pr2 : Person   | pr2->p2 in projects => pr2 in Student
}

