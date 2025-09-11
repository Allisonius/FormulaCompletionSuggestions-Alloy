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
	
  	
  	all s: Student | all c: s.enrolled | some y, x: Project | y in s.projects && z in s.projects && y in c.projects && z in c.projects => z=y 
  
}

