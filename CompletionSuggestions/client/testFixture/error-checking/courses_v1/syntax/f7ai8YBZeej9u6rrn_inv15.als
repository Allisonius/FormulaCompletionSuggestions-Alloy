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
	
	all s1,s2:Student, p:Project, c:Course | (p in s1.projects and p in s2.projects and p in c.projects) implies (s1 in c.grades.Grade and s2 in c.grades.Grade implies s1.(c.grades)=prev[s2.(c.grades)] or s2.(c.grades)=prev[s1.(c.grades]))
}


