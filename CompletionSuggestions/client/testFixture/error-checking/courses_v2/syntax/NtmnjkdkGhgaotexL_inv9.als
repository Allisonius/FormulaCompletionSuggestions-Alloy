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

pred inv9{
	
  	
	all p1:Professor, p2:Professor, c:Course | p1 in teaches.c and p2 in teaches.c implies (all c2:Course | p1 in teaches.c2 implies p2 not in enrolled.c2)

