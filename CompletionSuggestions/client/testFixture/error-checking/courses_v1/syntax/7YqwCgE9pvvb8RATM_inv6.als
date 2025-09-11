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
	
  all p : Person | all pro : Project | pro in p.projects implies ( some c : Course | pro in c.projects and c in p.enrolled
  


}

