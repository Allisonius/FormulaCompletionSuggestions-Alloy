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
	
	all c : Course, p : Project, disj s,s2 : Student, g : Grade | c.grades[s] > c.grade[s2] => p in s.projects and p in c.projects
}

