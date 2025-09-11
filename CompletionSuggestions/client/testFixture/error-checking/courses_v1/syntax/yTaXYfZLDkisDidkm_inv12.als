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
	
    all c: Course | all p: Student | all g1: Grade | all g1: Grade |c->p->g1 in grades and c->p->g2 in grades implies g1=g2
}

