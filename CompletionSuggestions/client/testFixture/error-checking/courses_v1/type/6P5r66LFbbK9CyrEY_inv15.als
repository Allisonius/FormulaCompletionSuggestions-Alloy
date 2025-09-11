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
	
  	all disj s1, s2 : Student | all c : (s1.projects & s2.projects).~(Student <: projects) | s1.(c.grades) in s2.1.(c.grades) + next[s2.1.(c.grades)] + prev[s2.1.(c.grades)]
}


