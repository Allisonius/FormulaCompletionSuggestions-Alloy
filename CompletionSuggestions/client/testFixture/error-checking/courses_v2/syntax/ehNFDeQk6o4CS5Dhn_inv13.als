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
	
	all c : Course | all nerd : enrolled.c | (all dummy : enrolled.c | gte[nerd.(c.grade), nerd.(c.grade)])
    => 1 = 1 
}

