open util/ordering[Grade]

sig Person {
	teaches : set Course,
	enrolled : set Course,
	projects : set Project
}

sig Professor,Student in 

sig Course {
	projects : set Project,
	grades : Person -> Grade
}

sig Project {}

sig Grade {}