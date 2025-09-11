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
	
	all disj s1, s2 Student | some s1.projects & s2.projects implies all m1 : s1.(Course.grades), m2 : s2.(Course.grades) | m1 in m2 + prev[m2] + next[m2]
}


