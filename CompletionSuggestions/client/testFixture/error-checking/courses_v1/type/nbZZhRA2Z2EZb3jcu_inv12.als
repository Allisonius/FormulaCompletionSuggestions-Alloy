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
	
	all s : Student | all c : Course | all g1,g2 : Grade | c->s->g1 in grades and c->s->g2 implies g1 = g2
}

