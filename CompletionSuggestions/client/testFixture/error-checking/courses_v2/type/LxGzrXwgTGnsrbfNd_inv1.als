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
	
  	all p: Person | all c: Course | (p in Professor implies (no c in p.enrolled)) and (p in Student implies (c in p.enrolled)) 
}

