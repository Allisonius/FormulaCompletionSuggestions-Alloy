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
	
  	
  	
	all s : Student | all c : Course | all proj1 : Project | all proj2 : Project | (proj1 in s.projects and proj2 in s.projects and proj1 in c.projects) implies proj2 not in c.projects
  
  
  c in s.enrolled implies #(s.projects)<1
}

