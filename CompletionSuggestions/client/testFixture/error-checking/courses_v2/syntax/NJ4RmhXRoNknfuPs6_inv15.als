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

pred inv15{
	
	all disj s1,s2 : Student, p : Project, c : Course | ((p in s1.projects && p in s2.projects && p in 																c.project) && s1.(c.grades) gte s2.(c.grades) implies s1.(c.grads) - s2.(c.grades) <= 1)) or 
														((p in s1.projects && p in s2.projects && p in c.project) && s1.(c.grades) lt s2.(c.grades) implies s2.(c.grads) - s1.(c.grades))
}


