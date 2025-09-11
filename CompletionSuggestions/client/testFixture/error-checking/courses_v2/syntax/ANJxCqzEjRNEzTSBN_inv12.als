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
 all g1,g2:Grade | all s:Student | all c1,c2:Course | (c1 in s.enrolled and c2 in s.enrolled and s->g1 in c1.grades and s->g2 in c2.grades and ) implies c1!=c2
 
	

}

