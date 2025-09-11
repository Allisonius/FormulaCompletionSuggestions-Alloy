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
	
	all c:Course | one s1:Student | (no s2:Student-s1 | (c.grades[s2] > c.grades[s1])) => one c.grades[s1] 
}

