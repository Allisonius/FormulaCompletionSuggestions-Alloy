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
	
	all p1,p2:Professor | #(p1.enrolled & p2.teaches) > 0 implies #(p1.teaches & p2.enrolled) == 0
}

