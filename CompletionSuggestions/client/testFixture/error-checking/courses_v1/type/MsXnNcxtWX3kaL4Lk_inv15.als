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

pred inv15{
	
	all disj s, s1 : Student | all p : s.projects & s1.projects | s1.(Course <: projects).p.grades  next[s.(Course <: projects).p.grades] 
  	
}


