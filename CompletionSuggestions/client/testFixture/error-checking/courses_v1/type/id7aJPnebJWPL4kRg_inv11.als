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

pred inv11{
  	
	
  	one p1 : Person | all c : Course | (c in (grades.Grade.p1)) in s.enrolled
	all c:Course, s:Person, g:Grade | (s->g).~grades in s.enrolled
}

