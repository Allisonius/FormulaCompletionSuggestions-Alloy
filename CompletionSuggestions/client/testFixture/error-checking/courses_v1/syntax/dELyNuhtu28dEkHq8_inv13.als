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
	
	all s : Student, c : Course, g : Grade | s = c.grades.max[Student.(c.grades)] => one (s.projects & c.projects) s.projects) 
}

