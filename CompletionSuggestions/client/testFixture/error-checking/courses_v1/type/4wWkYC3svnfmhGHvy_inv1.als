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
	
	all p:Person.enrolled | all s:Student.enrolled | all pr:Professor.enrolled | (p in s) and (s & pr)
}

