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

pred inv1{
	all p : Professor , p2 : Person, s : student| no p.enrolled + p2.enrolled and no p.teaches & p.enrolled 

}

