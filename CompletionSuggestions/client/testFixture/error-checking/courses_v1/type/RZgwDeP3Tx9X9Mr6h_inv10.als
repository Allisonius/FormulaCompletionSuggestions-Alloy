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

pred inv10{
	
  all p1 : Person | all c1 : Course | all g1 : Grade|
  	(c1->p1->g1 in grades) implies (p1 in Student)
  	all c:Course, p:Person | c.grades.p
	
}

