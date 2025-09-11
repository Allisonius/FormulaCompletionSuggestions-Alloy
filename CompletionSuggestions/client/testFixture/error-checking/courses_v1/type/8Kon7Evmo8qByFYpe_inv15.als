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
	
	all s1,s2:Student, p:Project, c:Course, g1,g2:Grade | (s1!=s2 and p in s1.projects and p in s2.projects and p in c.projects) implies (g1 in s1.grades and g2 in s2.grades implies (g1=prev[g2] or g2=prev[g1])) 
}


