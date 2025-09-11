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

pred inv12{
	
  	all g1,g2:Grade,s:Student,c:Course | g1 in s.enrolled.c.grades implies g1 in s.enrolled.c.grades
}

