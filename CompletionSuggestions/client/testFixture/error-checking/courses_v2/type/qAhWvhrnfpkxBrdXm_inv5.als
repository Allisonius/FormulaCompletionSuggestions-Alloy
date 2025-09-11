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
	
	
	all p : Project, pe : Person | p in projects.pe implies pe in Student 
  	all p : Project | some pe : Person | pe in projects.p
}

