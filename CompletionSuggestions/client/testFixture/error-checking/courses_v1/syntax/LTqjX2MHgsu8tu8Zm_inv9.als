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
	
	all p1,p2 : Professor | all c : Course | p1 != p2 and c in p1.teaches and c in p2.teaches (some c2 : Course | c2 in p1.teaches implies 2 not in p2.enrolled
}

