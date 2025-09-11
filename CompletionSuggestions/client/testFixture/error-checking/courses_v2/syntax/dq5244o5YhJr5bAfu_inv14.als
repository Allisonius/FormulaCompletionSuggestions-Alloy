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

pred inv14{
	
  all p1,p2 : Person | all pro1,pro2 | (pro1 in p1.projects and pro1 in p2.projects and pro2 in p1.projects and pro1 != pro2) implies pro2 not in p2.projects  

}

