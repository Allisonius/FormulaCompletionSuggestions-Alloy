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
	
	all disj p1,p2 : Project, disj s1,s2: Student, c : Course | p1 in s1.projects and p1 in s2.projects and p1 in c.projects => c.grades[s1] - c.grades[s2] > 1
}


