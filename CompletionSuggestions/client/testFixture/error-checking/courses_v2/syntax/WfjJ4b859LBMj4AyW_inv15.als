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
	
  	all s1, s2: Student | all c: Course, p: c.projects, g: Grade | (p in s1.projects && p in s2.projects) implies (s1->g = (s2->.g).plus[1] or s2->g = (s1->g).plus[1])
}


