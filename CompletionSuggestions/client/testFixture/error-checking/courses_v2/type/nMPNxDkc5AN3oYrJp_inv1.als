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
	
  	all p: Person | all c: Course | p in Professor implies (c not in p.enrolled)
    all s: Person | all c: Course | s in Student implies (some c in p.enrolled)
}

