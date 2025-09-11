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

pred inv13{
	
 all c : Course, all pM : Student | (all p : Student |  gte[pM.(c.grades), p.(c.grades)]) implies some pM.projects & c.projects
}

