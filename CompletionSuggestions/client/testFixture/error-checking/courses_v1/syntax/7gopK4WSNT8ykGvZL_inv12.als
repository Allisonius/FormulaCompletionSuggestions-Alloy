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
  
  all s:Student, c:Course, p1,p2:Project | p1 in s.projects and p2 in s.projects and c in s.enrolled and p1 in c.projects and p2 in c.projects implies p1=p2
	
	all s:Student, c:Course, g1,g2: Grade | g1 in c.grades.Person and g2 in c.grades.Person and c

