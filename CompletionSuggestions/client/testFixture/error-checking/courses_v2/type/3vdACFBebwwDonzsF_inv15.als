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
	
	all disj s1,s2 : Student, p : Project,c: Course, g1,g2 : Grade | ((p in s1.projects && p in s2.projects) && g1 in s1.(c.grades) && g2 in s2.(c.grades) && gte[g1,g2] implies #g1 - #g2 <= 1) or 
														((p in s1.projects && p in s2.projects) && g1 in s1.(c.grades) && g2 in s2.(c.grades) && lt[g1,g2] implies g2 - g1 <= 1)
}


