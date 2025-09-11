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
	
	all p2:Professor |all p:Person | all c1,c2:Course | p1->c1 in teaches and p->c1 in enrolled implies p in Student
}

