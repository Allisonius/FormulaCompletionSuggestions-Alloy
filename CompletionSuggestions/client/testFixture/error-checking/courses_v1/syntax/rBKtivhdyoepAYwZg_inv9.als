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
	
	one p1:Profeesor | all p2: Professor, c: Course | p1 -> c in teaches and not(p2 -> c in enrolled)
}

