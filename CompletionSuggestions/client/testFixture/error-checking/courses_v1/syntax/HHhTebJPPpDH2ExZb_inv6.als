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

pred inv6{
	

  
  all p : Person | all pr : Project | pr in p.projects implies (some c : Course | pr in c1.projects and c in p.enrolled)
  
  
}

