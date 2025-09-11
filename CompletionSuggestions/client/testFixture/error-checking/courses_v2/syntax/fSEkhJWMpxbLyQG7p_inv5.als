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
	
	

  (all pro : Projects | all p : Person | p->pro in projects implies p in Student)
  (all p2 : Project | all pr2 : Person   | pr2->p2 in projects implies pr2 in Student)
}

