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
	
  	all disj s1,s2 : Student | all c : Course | all p: c.projects | p in s1.projects and p in s2.projects => (s1.(c.grades)) = minus[(s2.(c.grades)),1] or (s1.(c.grades)) = (s2.(c.grades)) -1
  
 
}


