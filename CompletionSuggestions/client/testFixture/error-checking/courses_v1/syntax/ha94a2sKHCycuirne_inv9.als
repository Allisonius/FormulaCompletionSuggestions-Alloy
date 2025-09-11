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
	

	all s : Student | all p : Professor | all c,c2 : Course | c in p1.enrolled and c in p2.teaches implies (c2 not in p1.enrolled and c2 not in p2.enrolled) 
}

