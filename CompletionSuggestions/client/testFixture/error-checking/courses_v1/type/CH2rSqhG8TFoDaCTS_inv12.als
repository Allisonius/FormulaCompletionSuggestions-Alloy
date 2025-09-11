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
	
	all s1: Student | all g1, g2: Grade | all c1: Course |
  	((s1->g1 in grades) and (s1->g2 in grades) and (c1->g1 in grades) and (c1->g2 in grades)) imples g1=g2
}

