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
	
  	all p: Person | p in Professor => p not in c.~enrolled
    all p: Person | p in Student => p in c.~enrolled
}

