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
	
	all c : course | all nerd : enrolled.course | (all dummy : enrolled.course | gte[nerd.(course.grade), nerd.(course.grade)])
    => 1 = 1 
}

