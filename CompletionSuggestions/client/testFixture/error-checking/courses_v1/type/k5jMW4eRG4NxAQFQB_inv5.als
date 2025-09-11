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
	
	
  	some p : Person, c : Course | all pr : projects | no ( p & Student ) implies c not in p.enrolled and pr in s.projects
  	
}

