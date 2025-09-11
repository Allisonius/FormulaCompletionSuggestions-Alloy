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
	
	all t1,t2 : Professor, c : Course | c in t.teaches && c in t2.teaches implies (all t2 : Professor | c not in t2.enrolled and t2!= t1 and c not in t2.teaches) 
}

