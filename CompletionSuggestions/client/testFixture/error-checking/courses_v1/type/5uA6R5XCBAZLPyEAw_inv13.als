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
	
  	all c : Course | some s : Student | s in c.grades
	all c : Course | some s : Student | no (s.(c.grades)).next implies s.projects in c.projects
}

