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

pred inv8{
	
	all p : Professor | all e : Person | all c : Course | c1 in e.enrolled and c1 in p.teaches implies p!=e
}

