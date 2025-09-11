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
	

all p : Project | all s1,s2 : Student | all c : Course |s1!=s2 and p in s1.projects and p in s2.projects and p in c.projects implies (all g1, g2 : Grade | g1 in s1.c.grades and g2 in s2.c.grades implies (g1 = prev[g2] or g2 = prev[g1] or g1=g2))
}


