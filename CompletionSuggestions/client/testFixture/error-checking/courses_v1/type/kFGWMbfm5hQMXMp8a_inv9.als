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

pred inv9{
	
  
  all p1,p2 : Person | all c : Course | p1->c in teaches and p2 -> c implies p1 in Professor and p2 in Student
}

