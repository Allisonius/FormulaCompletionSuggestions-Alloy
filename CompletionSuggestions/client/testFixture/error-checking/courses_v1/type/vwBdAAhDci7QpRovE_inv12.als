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
	
 all s : Student | all g1, g2 : Grade | all c : Course | s->g1 in c.grades.Grade and s->g2 in c.grades.Grade implies g1 = g2

}

