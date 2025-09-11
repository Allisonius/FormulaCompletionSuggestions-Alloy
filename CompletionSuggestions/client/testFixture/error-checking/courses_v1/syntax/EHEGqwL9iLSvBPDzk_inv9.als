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
	
	all c1,c2 : Course, disj p0,p1 : Professor | c in p0.teaches && c in p1.enrolled => c1!=c2
}

