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
	
	all c:Course, p:c.projects, s1, s2: Person, g1,g2:Grade | 
  		s1 != s2 and c->s1->g1 in grades and c->s2->g2 in grades


