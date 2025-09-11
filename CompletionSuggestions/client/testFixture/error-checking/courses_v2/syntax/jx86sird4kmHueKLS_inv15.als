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
	
	all s1, s2 : Student | (s1 != s2) => (all c : s1.enrolled & s2.enrolled | (all p : c.projects & s1.projects & s2.projects | abs(s1.grades.c - s2.grades.c) <= 1))
}


