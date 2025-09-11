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
	
	
	all s : Person | all p : Project |  (s in projects.p) and (s in Student) 
  	all  p : Project | some s : User | s in projects.p
  	

}

