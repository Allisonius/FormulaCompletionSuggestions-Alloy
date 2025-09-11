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
	
	
   all disj p,pp: Person | all c: Course | p in c.~teaches && pp in c.~teaches => p not in c.~enrolled & pp not in c.~enrolled 
}

