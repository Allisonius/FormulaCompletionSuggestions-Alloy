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

pred inv15{
	
	all c : Course, disj s1, s2 : Student | c in (s1.enrolled & s2.enrolled) and (c.grades.s1 > c.grades.s2 + 1 or c.grades.s1 < c.grades.s2 - 1) implies (s1.projects & s2.projects) not in c.projects
}


